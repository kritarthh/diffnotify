from PIL import Image
import sys

mode = sys.argv[1]
old = sys.argv[2]
new = sys.argv[3]
start_x_fraction = float(sys.argv[4])
start_y_fraction = float(sys.argv[5])
end_x_fraction = float(sys.argv[6])
end_y_fraction = float(sys.argv[7])

i1 = Image.open(old)
i2 = Image.open(new)

assert i1.mode == i2.mode, "Different kinds of images."
assert i1.size == i2.size, "Different sizes."

area = (
    int(start_x_fraction * i1.size[0]),
    int(start_y_fraction * i1.size[1]),
    int(end_x_fraction * i1.size[0]),
    int(end_y_fraction * i1.size[1])
)
i1 = i1.crop(area)
i2 = i2.crop(area)

if mode == 'test':
    print("testing...")
    i1.save("cropped_%s" % old)
    print("cropped_%s saved." % old)
    sys.exit()

pairs = zip(i1.getdata(), i2.getdata())
if len(i1.getbands()) == 1:
    # for gray-scale jpegs
    dif = sum(abs(p1-p2) for p1,p2 in pairs)
else:
    dif = sum(abs(c1-c2) for p1,p2 in pairs for c1,c2 in zip(p1,p2))

ncomponents = i1.size[0] * i1.size[1] * 3
per_diff = (dif / 255.0 * 100) / ncomponents
print(per_diff)

