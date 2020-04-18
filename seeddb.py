# -*- coding: utf-8 -*-
import jinja2
import jinja2plugin
import jinja2tool
import cherrypy
import os

class SeedDb(object):
    @cherrypy.expose
    def index(self):
        return {}

    @cherrypy.expose
    def seedlist(self):
        return {}

if __name__ == '__main__':
    conf = {
        '/': {
            'tools.sessions.on': True,
            'tools.staticdir.root': os.path.abspath(os.getcwd()),
            'tools.template.on': True,
            'tools.template.template': 'index.html',
            'tools.encode.on': True,
            'tools.encode.encoding': 'utf-8'
        },
        '/seedlist': {
            'tools.template.template': 'seedlist.html'
        },

        '/static': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': './public'
        }
    }

    jinja_env = jinja2.Environment(
        loader=jinja2.FileSystemLoader('./templates'),
        autoescape=jinja2.select_autoescape(
            enabled_extensions=('html', 'xml'),
            default_for_string=True,
        )
    )    
    jinja2plugin.Jinja2TemplatePlugin(cherrypy.engine, jinja_env).subscribe()
    cherrypy.tools.template = jinja2tool.Jinja2Tool()
    cherrypy.quickstart(SeedDb(), '', conf)

