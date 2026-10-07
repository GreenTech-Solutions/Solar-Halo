"""Recolors Vulcanus' lava texture into the yellow of the solar surface.

Not part of the mod itself: run it when the colors need changing, and commit
the result (space/lava-solar.png). Needs Pillow and numpy.

    python tools/recolor-lava.py [path to space-age's lava.png]

The brightness of every pixel of the original is run through the gradient
below, so the structure of the lava (where it is hot, where it is crust) is
kept and only the colors change. Edit RAMP to change them.
"""
import sys
import numpy as np
from PIL import Image

SOURCE = "C:/Program Files (x86)/Steam/steamapps/common/Factorio/data/space-age/graphics/terrain/vulcanus/lava-textures/lava.png"
TARGET = __file__.replace("\\", "/").rsplit("/tools/", 1)[0] + "/space/lava-solar.png"

# (brightness 0..1, (r, g, b)): dark crust, glowing amber, gold, hot yellow
RAMP = [
    (0.00, (22, 8, 0)),
    (0.25, (120, 50, 0)),
    (0.50, (230, 140, 0)),
    (0.75, (255, 210, 30)),
    (1.00, (255, 250, 150)),
]

source = sys.argv[1] if len(sys.argv) > 1 else SOURCE
image = np.asarray(Image.open(source).convert("RGB")).astype(float)
luma = 0.299 * image[..., 0] + 0.587 * image[..., 1] + 0.114 * image[..., 2]
low, high = np.percentile(luma, [1, 99])
t = np.clip((luma - low) / (high - low), 0, 1)

stops = np.array([stop for stop, _ in RAMP])
out = np.stack([np.interp(t, stops, [color[c] for _, color in RAMP]) for c in range(3)], axis=-1)

Image.fromarray(out.round().astype("uint8"), "RGB").save(TARGET, optimize=True)
print("wrote", TARGET)
