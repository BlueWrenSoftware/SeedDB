# -*- coding: utf-8 -*-
import cherrypy
import sqlite3
import os

class SeedDb(object):
    @cherrypy.expose
    def index(self):
        return {}

    @cherrypy.expose
    def seedlist(self):
        with sqlite3.connect('./db/seed.db') as conn:
            curs = conn.cursor()
            curs.execute('SELECT * FROM ViewSeedList;')
            ret = {'data': curs.fetchall()}
            return ret

if __name__ == '__main__':
    conf = {
        '/': {
            'tools.sessions.on': True,
            'tools.staticdir.root': os.path.abspath(os.getcwd()),
            'tools.template.on': True,
            'tools.template.template': 'index.html',
            'tools.encode.on': False
        },
        '/seedlist': {
            'tools.template.template': 'seedlist.html'
        },

        '/static': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': './public'
        }
    }

    
    # Register the Mako plugin
    from makoplugin import MakoTemplatePlugin
    MakoTemplatePlugin(cherrypy.engine, base_dir=os.path.join(os.getcwd(), 'templates')).subscribe()

    # Register the Mako tool
    from makotool import MakoTool
    cherrypy.tools.template = MakoTool()
    cherrypy.quickstart(SeedDb(), '', conf)

