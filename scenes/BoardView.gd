extends Node2D
class_name BoardView

# ------- Tunables -------
const PIXEL_SIZE := Vector2(3, 3)
const BUDGET_MS := 4           # time budget per frame to spawn pixels
const CHUNK_GROW := 256        # how much capacity we add at a time
const GRID_CELL := 32.0        # background grid size

# ------- State -------
var children_lines: Array[Line2D] = []
var _pending: Array[Vector2] = []     # positions queued to spawn (non-blocking)
var _t := 0.0                         # time accumulator
var _focus := Vector2.ZERO            # last piece position (for focus pulse)

# Background
var _bg: ColorRect

# MultiMesh (super fast instanced 2D quads)
var _mm: MultiMesh
var _mmi: MultiMeshInstance2D
var _next_idx := 0

func _ready() -> void:
	print("BoardView is ready")
	DomainBus.cmd_start_game.emit()

	DomainBus.evt_piece_added.connect(_on_piece_added)
	DomainBus.evt_pieces_added.connect(_on_pieces_added)

	for child in get_children():
		if child is Line2D:
			children_lines.append(child)

	_setup_background_grid()
	_setup_multimesh()

	# keep background full-screen
	get_viewport().size_changed.connect(_on_viewport_resized)
	_on_viewport_resized()

func _process(delta: float) -> void:
	_t += delta

	# animate lines & gently drift them toward the focus
	for line in children_lines:
		line.rotation += delta
		line.width = 2.0 + 2.0 * abs(sin(_t * 2.0))
		line.position = line.position.lerp(_focus, 0.08)

	# consume pending spawns within a small time budget (keeps FPS smooth)
	var start := Time.get_ticks_msec()
	while _pending.size() > 0 and Time.get_ticks_msec() - start < BUDGET_MS:
		var p: Vector2 = _pending.pop_front()
		_spawn_pixel(p)

	queue_redraw() # for the pulsing focus ring

func _draw() -> void:
	# pulsing focus ring where the latest piece landed
	var r := 10.0 + 6.0 * sin(_t * 6.0)
	draw_circle(_focus, r, Color(1, 0.6, 0.25, 0.22))
	draw_circle(_focus, 2.0, Color(1, 0.8, 0.4, 0.95))

# ---------- Fancy bits ----------

func _setup_background_grid() -> void:
	_bg = ColorRect.new()
	_bg.name = "NeonGrid"
	_bg.color = Color(0, 0, 0, 0) # fully driven by the shader
	_bg.z_index = -100

	var sh := Shader.new()
	# Uses SCREEN_UV so it works well on Web
	sh.code = """
shader_type canvas_item;

uniform vec4 grid_color : source_color = vec4(0.15, 0.18, 0.28, 1.0);
uniform float cell = 32.0;
uniform float thickness = 1.0;
uniform float glow = 0.15;

void fragment() {
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 px = SCREEN_UV * screen_size; // pixel coords
	vec2 uv = px / cell;

	vec2 g = abs(fract(uv) - 0.5);
	float d = min(g.x, g.y);

	float w = thickness / cell;
	float line = 1.0 - smoothstep(0.5 - w, 0.5, d);
	float halo = 1.0 - smoothstep(0.45, 0.5, d);

	float pulse = 0.5 + 0.5 * sin(TIME * 1.5);
	vec3 bg = vec3(0.02, 0.02, 0.03);
	vec3 col = mix(bg, grid_color.rgb, line + glow * pulse * halo);
	COLOR = vec4(col, 1.0);
}
"""
	var mat := ShaderMaterial.new()
	mat.shader = sh
	_bg.material = mat
	add_child(_bg)

func _on_viewport_resized() -> void:
	if is_instance_valid(_bg):
		_bg.size = get_viewport_rect().size
		# update cell size uniform if you want to expose it:
		var mat := _bg.material as ShaderMaterial
		if mat:
			mat.set_shader_parameter("cell", GRID_CELL)

func _setup_multimesh() -> void:
	var quad := QuadMesh.new()
	quad.size = PIXEL_SIZE

	_mm = MultiMesh.new()
	_mm.transform_format = MultiMesh.TRANSFORM_2D

	# Version-safe color setup
	_mm.use_colors = true
	_mm.use_custom_data = false

	_mm.mesh = quad
	_mm.instance_count = 0
	_mm.visible_instance_count = 0

	_mmi = MultiMeshInstance2D.new()
	_mmi.name = "Pixels"
	_mmi.multimesh = _mm
	add_child(_mmi)


func _ensure_capacity(next_index: int) -> void:
	if next_index < _mm.instance_count:
		return
	_mm.visible_instance_count = _next_idx
	var old := _mm.instance_count
	var new_count := next_index + CHUNK_GROW
	_mm.instance_count = new_count
	var off := Vector2(-10000, -10000)
	for i in range(old, new_count):
		_mm.set_instance_transform_2d(i, Transform2D(0.0, off))
		_mm.set_instance_color(i, Color(0, 0, 0, 0))

func _spawn_pixel(p: Vector2) -> void:
	_ensure_capacity(_next_idx)

	_mm.set_instance_transform_2d(_next_idx, Transform2D(0.0, p))

	var hue := fmod((_t * 0.1) + p.x * 0.002 + p.y * 0.002, 1.0)
	_mm.set_instance_color(_next_idx, Color.from_hsv(hue, 0.85, 1.0, 1.0))

	_next_idx += 1
	_mm.visible_instance_count = _next_idx
	_focus = p

func clear_pixels() -> void:
	_next_idx = 0
	if _mm:
		_mm.visible_instance_count = 0

# ---------- Signals ----------

func _on_pieces_added(positions: Array[Dictionary]) -> void:
	# enqueue everything; the per-frame budget will spawn them smoothly
	for pos in positions:
		var v := pos.get("position", null) as Dictionary
		if v != null:
			_pending.append(Vector2(v.get("x", 0), v.get("y", 0)))

func _on_piece_added(id: int, x:int, y:int) -> void:
	print("BoardView: Piece added: ", id, " at (", x, ",", y, ")")
	_pending.append(Vector2(x, y))
