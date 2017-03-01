import json, socket, subprocess, sys

PORT = 8034

#TODO add ability for backend to send audio interfaces to frontend
'''
def frontend(obj):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.bind(('', PORT))
        sock.listen(1)
        conn, addr = sock.accept()
        jbytes = sock.recv(4096)
        obj = json.loads(jbytes.decode('utf-8'))
        conn.sendall(json.dumps(obj).encode('utf-8'))
        return obj
    finally:
        sock.close()

def backend(list_audio_interfaces_input, list_audio_interfaces_output):
    def getIp():
        return subprocess.check_output(['ip', 'neighbor']).split()[0]
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect((getIp(), PORT))
        sock.sendall(json.dumps({
        	'inputs': list_audio_interfaces_input,
        	'outputs': list_audio_interfaces_output,
		}).encode('utf-8'));
        jbytes = sock.recv(4096)
        obj = json.loads(jbytes.decode('utf-8'))
        return obj
    finally:
        sock.close()
'''
def frontend(obj):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.bind(('', PORT))
        sock.listen(1)
        conn, addr = sock.accept()
        conn.sendall(json.dumps(obj).encode('utf-8'))
    finally:
        sock.close()

def backend():
    def getIp():
        return subprocess.check_output(['ip', 'neighbor']).split()[0]
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        sock.connect((getIp(), PORT))
        jbytes = sock.recv(4096)
        obj = json.loads(jbytes.decode('utf-8'))
        return obj
    finally:
        sock.close()

if __name__ == '__main__':
    #USAGE bridge <frontend|backend>
    #run the frontend THEN the backend
    if sys.argv[1] == 'frontend':
        frontend(sys.stdin.read())
    elif sys.argv[1] == 'backend':
        sys.stdout.write(backend())