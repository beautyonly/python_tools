#coding=utf-8
  
from ftplib import FTP
import os
import os.path
import shutil
import datetime
 
  
def ftp_up(filename):
    ftp=FTP() 
    ftp.set_debuglevel(2)#打开调试级别2，显示详细信息;0为关闭调试信息 
    ftp.connect('10.7.39.29','888')#连接 
    ftp.login('happ','happ')#登录，如果匿名登录则用空串代替即可 
    print ftp.getwelcome()#显示ftp服务器欢迎信息
    try:
        ftp.mkd('+CYOUEMT')  
    except:  
        print('dir has existed %s' % '+CYOUEMT')
 
    ftp.cwd('+CYOUEMT') #选择操作目录 
    bufsize = 1024#设置缓冲块大小 
    file_handler = open(filename,'rb')#以读模式在本地打开文件 
    ftp.storbinary('STOR %s' % os.path.basename(filename),file_handler,bufsize)#上传文件 
    ftp.set_debuglevel(0) 
    file_handler.close() 
    ftp.quit() 
    print "ftp up OK" 
  
def ftp_down(host,port,user,passw,rootDir,locaDir): 
    ftp=FTP() 
    ftp.set_debuglevel(2) 
    ftp.connect(host,port) 
    ftp.login(user,passw) 
    print ftp.getwelcome()#显示ftp服务器欢迎信息 
    ftp.cwd(rootDir) #选择操作目录 
    files = ftp.nlst()
    for name in files:   
        bufsize = 1024 
        file_handler = open(locaDir + name,'wb').write #以写模式在本地打开文件 
        ftp.retrbinary('RETR %s' % os.path.basename(name),file_handler,bufsize)#接收服务器上文件并写入本地文件 
    ftp.set_debuglevel(0) 
    ftp.quit() 
    print "ftp down OK"
 
def copyFiles(sourceDir,  targetDir): 
    if sourceDir.find(".svn") > 0: 
        return 
    for file in os.listdir(sourceDir): 
        sourceFile = os.path.join(sourceDir,  file) 
        targetFile = os.path.join(targetDir,  file) 
        if os.path.isfile(sourceFile): 
            if not os.path.exists(targetDir):  
                os.makedirs(targetDir)  
            if not os.path.exists(targetFile) or(os.path.exists(targetFile) and (os.path.getsize(targetFile) != os.path.getsize(sourceFile))):  
                    open(targetFile, "wb").write(open(sourceFile, "rb").read()) 
        if os.path.isdir(sourceFile): 
            First_Directory = False 
            copyFiles(sourceFile, targetFile)
    print 'copy them to '+targetDir
 
 
#a.com
ftp_down('10.10.10.1','21','111',"123456",'happ','toftp/')
for root,dirs,files in os.walk('toftp'):
    for f in files:
        ftp_up(os.path.join(root,f))
 
#b.com

=======================================
#coding=utf-8
'''
    ftp自动下载、自动上传脚本，可以递归目录操作
'''
 
from ftplib import FTP
import os,sys,string,datetime,time
import socket
 
class MYFTP:
    def __init__(self,rootdir_local, hostaddr, username, password, remotedir, port=21):
        self.hostaddr = hostaddr
        self.username = username
        self.password = password
        self.remotedir  = remotedir
        self.port     = port
        self.ftp      = FTP()
        self.file_list = []
 
        self.rootdir_local = rootdir_local
        self.local_files = []
        self.remote_files = []
        self.appendFiles = []
        # self.ftp.set_debuglevel(2)
    def __del__(self):
        self.ftp.close()
        # self.ftp.set_debuglevel(0)
    def login(self):
        ftp = self.ftp
        try: 
            timeout = 300
            socket.setdefaulttimeout(timeout)
            ftp.set_pasv(True)
            print u'开始连接到 %s' %(self.hostaddr)
            ftp.connect(self.hostaddr, self.port)
            print u'成功连接到 %s' %(self.hostaddr)
            print u'开始登录到 %s' %(self.hostaddr)
            ftp.login(self.username, self.password)
            print u'成功登录到 %s' %(self.hostaddr)
            debug_print(ftp.getwelcome())
        except Exception:
            print u'连接或登录失败'
        try:
            ftp.cwd(self.remotedir)
        except(Exception):
            print u'切换目录失败'
 
    def margeFile(self):
        temp = []
        try:
            for f in self.remote_files:
                if f in self.local_files:
                    temp.append(f)
            for f in temp:
                self.remote_files.remove(f)
        except Exception,e:
            print e
 
    def get_localFileList(self,fileTxt):
        print u'从 %s 中读取本地文件列表'%(self.rootdir_local +'/'+fileTxt)
        try:
            fileTxt = open(rootdir_local+'/'+fileTxt,'r')
        except Exception,e:
            print e
        for line in fileTxt:
            line = line.strip('\n')
            line = line.strip(' ')
            self.local_files.append(line)
 
    def update_localFileList(self,fileTxt):
        print u'更新 %s 中文件列表'%(self.rootdir_local +'/'+fileTxt)
        try:
            fileTxt = open(rootdir_local+'/'+fileTxt,'a')
            fileTxt.writelines(['%s\n' %(x) for x in self.appendFiles])
        except Exception,e:
            print e
 
    def get_remoteFileList(self):
        print u'读取服务器文件列表'
        try:
            self.remote_files = self.ftp.nlst()
        except Exception,e:
            print e
 
    def download_file(self, localfile, remotefile):
        debug_print(u'>>>>>>>>>>>>下载文件 %s <<<<<<<<<<<<' %localfile)
        #return
        file_handler = open(localfile, 'wb')
        self.ftp.retrbinary(u'RETR %s'%(remotefile), file_handler.write)
        file_handler.close()
        self.appendFiles.append(remotefile)
 
    def download_marge_files(self):
        for f in self.remote_files:
            self.download_file(rootdir_local+'/'+f,f)
'''
    #暂时不需要这些逻辑
    def download_files(self, localdir='./', remotedir='./'):
        try:
            self.ftp.cwd(remotedir)
        except:
            debug_print(u'目录%s不存在，继续...' %remotedir)
            return
        if not os.path.isdir(localdir):
            os.makedirs(localdir)
        debug_print(u'切换至目录 %s' %self.ftp.pwd())
        self.file_list = []
        self.ftp.dir(self.get_file_list)
        remotenames = self.file_list
        #print(remotenames)
        #return
        for item in remotenames:
            filetype = item[0]
            filename = item[1]
            local = os.path.join(localdir, filename)
            if filetype == 'd':
                self.download_files(local, filename)
            elif filetype == '-':
                self.download_file(local, filename)
        self.ftp.cwd('..')
        debug_print(u'返回上层目录 %s' %self.ftp.pwd())
 
    def upload_file(self, localfile, remotefile):
        if not os.path.isfile(localfile):
            return
        if self.is_same_size(localfile, remotefile):
            debug_print(u'跳过[相等]: %s' %localfile)
            return
        file_handler = open(localfile, 'rb')
        self.ftp.storbinary('STOR %s' %remotefile, file_handler)
        file_handler.close()
        debug_print(u'已传送: %s' %localfile)
    def upload_files(self, localdir='./', remotedir = './'):
        if not os.path.isdir(localdir):
            return
        localnames = os.listdir(localdir)
        self.ftp.cwd(remotedir)
        for item in localnames:
            src = os.path.join(localdir, item)
            if os.path.isdir(src):
                try:
                    self.ftp.mkd(item)
                except:
                    debug_print(u'目录已存在 %s' %item)
                self.upload_files(src, item)
            else:
                self.upload_file(src, item)
        self.ftp.cwd('..')
 
    def get_file_list(self, line):
        ret_arr = []
        file_arr = self.get_filename(line)
        if file_arr[1] not in ['.', '..']:
            self.file_list.append(file_arr)
             
    def get_filename(self, line):
        pos = line.rfind(':')
        while(line[pos] != ' '):
            pos += 1
        while(line[pos] == ' '):
            pos += 1
        file_arr = [line[0], line[pos:]]
        return file_arr
'''    
def debug_print(s):
    print s
 
if __name__ == '__main__':
    timenow  = time.localtime()
    datenow  = time.strftime('%Y-%m-%d', timenow)
    # 配置如下变量
    hostaddr = '10.6.152.147' # ftp地址
    username = 'anonymous' # 用户名
    password = 'anonymous@' # 密码
    port  =  21   # 端口号 
    rootdir_local  = 'E:/mypiv' # 本地目录
    rootdir_remote = '/'          # 远程目录
    local_file_list_txt = 'fileList.txt'
    while :
        f = MYFTP(rootdir_local,hostaddr, username, password, rootdir_remote, port)
        f.login()
        f.get_localFileList(local_file_list_txt)
        f.get_remoteFileList()
        f.margeFile()
        print f.remote_files
        f.download_marge_files()
        f.update_localFileList(local_file_list_txt)
        timenow  = time.localtime()
        datenow  = time.strftime('%Y-%m-%d %h:%M:%s', timenow)
        logstr = u"%s 成功执行了备份\n" %datenow
        debug_print(logstr)