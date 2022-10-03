from pynput import keyboard
import time
from threading import Thread,Event 
import pyautogui
import configparser
from playsound import playsound
import extcolors

cmb = [{keyboard.Key.alt_l, keyboard.KeyCode(char='0')}, 
{keyboard.Key.alt_l, keyboard.KeyCode(char='1')},
{keyboard.Key.alt_l, keyboard.KeyCode(char='2')},
{keyboard.Key.alt_l, keyboard.KeyCode(char='3')},
{keyboard.Key.alt_l, keyboard.KeyCode(char='4')},
{keyboard.Key.alt_gr, keyboard.KeyCode(char='0')},
{keyboard.Key.alt_gr, keyboard.KeyCode(char='1')},
{keyboard.Key.alt_gr, keyboard.KeyCode(char='2')},
{keyboard.Key.alt_gr, keyboard.KeyCode(char='3')},
{keyboard.Key.alt_gr, keyboard.KeyCode(char='4')}]

current = set()






def service(event):
    config = configparser.ConfigParser()
    config.read('config.ini')
    alarm_name = config['main']['alarm_name']
    x1 = int(config['main']['x1'])
    y1 = int(config['main']['y1'])
    x2 = int(config['main']['x2'])
    y2 = int(config['main']['y2'])
    refresh_timer = int(config['main']['refresh'])
    while not event.is_set():
        screen = pyautogui.screenshot('img.png',region=(x1,y1,x2,y2)) 
        colors = extcolors.extract_from_path('img.png', tolerance = 0, limit = 12)
        red_color = (242, 73, 92)
        curpos = pyautogui.position()
        pyautogui.moveTo(x1, y1, 0)
        pyautogui.leftClick()
        pyautogui.moveTo(x1, y1, 0)
        for example in colors[0]:
            if red_color == example[0]:
                print("alert")
                playsound(alarm_name)
            
                
        
        #print(result)
        time.sleep(refresh_timer) 

stop_event = Event()

def execute(cur):
    #print(cur)
    if keyboard.KeyCode(char='1') in current: #set coords under cursor as left top corner
        pos = pyautogui.position()
        config = configparser.ConfigParser()
        config.read('config.ini')
        config.set('main', 'x1', str(pos.x))
        config.set('main', 'y1', str(pos.y))
        with open("config.ini", 'w') as cfgfile:
            config.write(cfgfile)
        print('set1')
    if keyboard.KeyCode(char='2') in current: #counts height and width when cursor showing bottom right corner
        pos = pyautogui.position()
        config = configparser.ConfigParser()
        config.read('config.ini')
        x1 = int(config['main']['x1'])
        y1 = int(config['main']['y1'])
        config.set('main', 'x2', str(pos.x-x1))
        config.set('main', 'y2', str(pos.y-y1))
        with open("config.ini", 'w') as cfgfile:
            config.write(cfgfile)
        print('set2')
    if keyboard.KeyCode(char='3') in current: #start service
        stop_event.set()
        stop_event.clear()
        thread = Thread(target=service, args=(stop_event,), daemon=True)
        thread.start()
        print('start')
    if keyboard.KeyCode(char='4') in current: #stop service
        stop_event.set()
        print('stop')

def on_press(key):
    #print(key)
    if any([key in z for z in cmb]):
        current.add(key)
        if any(all(k in current for k in z) for z in cmb): #exit or doing
            if keyboard.KeyCode(char='0') in current:
                return False
            execute(current)

def on_release(key):
    if any([key in z for z in cmb]):
        current.clear()



            


with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()

 
