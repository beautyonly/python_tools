# -*- coding: utf-8 -*-
from flask import Flask, request, render_template, jsonify, json
import  redis
 
app = Flask(__name__)
 
@app.route('/api/<id>', methods=['GET'])
def scan(id):
     redis_client = redis.StrictRedis(host='127.0.0.1',port=6379,db=0,password='strong')
     get_key = redis_client.keys(id)
     if not get_key :
            json_result = {'id' : None}
            return json.dumps(json_result,ensure_ascii=False)
     else:
            get_key = redis_client.hmget(id,'name','password','email','phone')
            json_result = {'id'   : str(id),
                           'name' : get_key[0],
                           'pass' : get_key[1],
                           'email': get_key[2],
                           'phone': get_key[3]
                          }
 
            return json.dumps(json_result,ensure_ascii=False)
 
 
@app.route('/')
def index():
    return render_template('index.html')
 
 
if __name__ == '__main__':
  app.run(host='0.0.0.0', port = 808, debug=True)
