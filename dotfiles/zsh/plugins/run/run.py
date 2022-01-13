import os
import sys
import json

def _cpp(file):
    cmd = "g++ -Wall -Wextra -Werror -fsanitize=address,undefined -g -DDEBUG %s -o /tmp/%s.out" % (file, file)
    compile_result = os.system(cmd)
    if compile_result == 0:
        return os.system("/tmp/%s.out" % file)
    else:
        return compile_result

def _py(file):
    return os.system("python %s" % file)


runMap = {
        'cpp': _cpp,
        'py': _py,
}

def run(file_name):
    ext = os.path.splitext(file_name)[-1][1:]
    if ext not in runMap:
        print("%s is not supported!" % ext)
    else:
        func = runMap[ext]
        result = func(file_name)
        if result != 0:
            print("Program exit with %d" % result)

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print("Usuage: run <file>")
        sys.exit()
    file = sys.argv[-1]
    run(file)
    

