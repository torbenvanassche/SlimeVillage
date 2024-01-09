import glob
import re

for path in glob.glob("../**/*.glb.import", recursive=True):
    lines = []

    file = open(path, "r")
    for line in file.readlines():
        if "use_external/path" in line:
            part_i_care_about = line.split('"')[3]
            if re.match("^(?!.*\/polygon\/).*polygon_.*$", part_i_care_about):
                line = line.replace("materials", "materials/polygon")
        lines.append(line)
    file.close()

    file = open(path, "w")
    file.writelines(lines)
    file.close()
