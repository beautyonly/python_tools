import os

PATH = '/home/work/report'



LEVEL = 1

def dirs_name():
    root_depth = len(PATH.split(os.path.sep))
    d = {}

    for root, dirs, files in os.walk(PATH, topdown=True):

        """ print dirs """
        for name in dirs:
            dir_path = os.path.join(root, name)
            dir_depth = len(dir_path.split(os.path.sep))
            if dir_depth == root_depth + LEVEL:
                d[name] = {}
                d[name]['name'] = name
            
    return d

if __name__ == '__main__':
    dirs_name()
    # print(os.path.dirname(PATH))
    

