import re
import os

files = [
    'lib/screens/ride_map_screen.dart',
    'lib/screens/client_details_screen.dart',
    'lib/screens/ride_finished_screen.dart',
    'lib/screens/chat_screen.dart',
    'lib/widgets/green_wave_painter.dart'
]

for file in files:
    if not os.path.exists(file):
        print(f"Skipping {file} - not found")
        continue

    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Make imports
    if "import 'package:flutter_screenutil/flutter_screenutil.dart';" not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:flutter_screenutil/flutter_screenutil.dart';")

    # FontSize
    content = re.sub(r'(fontSize:\s*)([0-9]+)(\b)', r'\1\2.sp\3', content)

    # Width, height in SizedBox and Container
    content = re.sub(r'(width:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.w', content)
    content = re.sub(r'(height:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.h', content)
    content = re.sub(r'(radius:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.r', content)
    content = re.sub(r'(size:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.sp', content)
    content = re.sub(r'(Radius\.circular\()([0-9]+(?![\.a-zA-Z]))(\))', r'\1\2.r\3', content)
    content = re.sub(r'(BorderRadius\.circular\()([0-9]+(?![\.a-zA-Z]))(\))', r'\1\2.r\3', content)

    # EdgeInsets 
    content = re.sub(r'(EdgeInsets\.symmetric\([^)]*horizontal:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.w', content)
    content = re.sub(r'(EdgeInsets\.symmetric\([^)]*vertical:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.h', content)
    content = re.sub(r'(EdgeInsets\.only\([^)]*left:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.w', content)
    content = re.sub(r'(EdgeInsets\.only\([^)]*right:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.w', content)
    content = re.sub(r'(EdgeInsets\.only\([^)]*top:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.h', content)
    content = re.sub(r'(EdgeInsets\.only\([^)]*bottom:\s*)([0-9]+(?![\.a-zA-Z]))', r'\1\2.h', content)
    content = re.sub(r'(EdgeInsets\.all\()([0-9]+(?![\.a-zA-Z]))(\))', r'\1\2.w\3', content)
    content = re.sub(r'(EdgeInsets\.fromLTRB\()([0-9]+(?![\.a-zA-Z]))(\s*,\s*)([0-9]+(?![\.a-zA-Z]))(\s*,\s*)([0-9]+(?![\.a-zA-Z]))(\s*,\s*)([0-9]+(?![\.a-zA-Z]))(\))', r'\1\2.w\3\4.h\5\6.w\7\8.h\9', content)

    # Remove const from modifiers that are now using screen util
    content = re.sub(r'const\s+(SizedBox\([^)]*\.([whr]|sp).*?\))', r'\1', content)
    content = re.sub(r'const\s+(EdgeInsets\.[a-zA-Z]+\([^)]*\.([whr]|sp).*?\))', r'\1', content)
    content = re.sub(r'const\s+(Padding\([^)]*padding:\s*EdgeInsets[^)]*\.([whr]|sp)[^}]*?\))', r'\1', content)
    content = re.sub(r'const\s+(Text\([^)]*fontSize:\s*[0-9]+\.sp[^)]*\))', r'\1', content)
    content = re.sub(r'const\s+(TextStyle\([^)]*fontSize:\s*[0-9]+\.sp[^)]*\))', r'\1', content)
    content = re.sub(r'const\s+(Icon\([^)]*size:\s*[0-9]+\.sp[^)]*\))', r'\1', content)

    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
        
print("Done")
