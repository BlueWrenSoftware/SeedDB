# -*- coding: utf-8 -*-
import cherrypy
import sqlite3
import os
import urllib.parse

class SeedDb(object):
    @cherrypy.expose
    def index(self):
        return {}

    @cherrypy.expose
    def seedlist(self):
        with sqlite3.connect('./db/seed.db') as conn:
            curs = conn.cursor()
            curs.execute('SELECT * FROM ViewSeedList;')            
            data = curs.fetchall()     
        return {'data': data}
    
    @cherrypy.expose
    def editpackets(self, variety_id):
        with sqlite3.connect('./db/seed.db') as conn:
            curs = conn.cursor()
            curs.execute('SELECT id_seed_type, seed_category FROM SeedTypes;')
            seedtypes = curs.fetchall()
            curs.execute('SELECT id_seed, seed_variety_name FROM Seeds;')
            varieties = curs.fetchall()
            curs.execute("""SELECT 	
                          id_seed_packet,
	                  id_seed,
                          packet_code,
                          date_purchased,
	                  date_use_by,
	                  seed_count,
	                  seed_gram,
	                  packet_treatment,
	                  storage_location
                        FROM SeedPackets                           
                        WHERE id_seed=?""", (variety_id,))
            data = curs.fetchall()
        return {
                'seedtypes': seedtypes,
                'varieties': varieties,
                'data': data
            }
        
    @cherrypy.expose
    def seedsubmit(self, packet_id, seed_type_id, variety_id, seed_count):
        d = list(zip(variety_id, seed_count, packet_id))
        if len(d) == 1:
            d = [(int(variety_id), int(seed_count), int(packet_id))]            
        with sqlite3.connect('./db/seed.db') as conn:            
            for x in d:
                conn.execute("""UPDATE SeedPackets
                                SET id_seed=?, seed_count=?
                                WHERE id_seed_packet=?""",x)
        raise cherrypy.HTTPRedirect('seedlist')


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
        '/editpackets': {
            'tools.template.template': 'editpackets.html'
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

