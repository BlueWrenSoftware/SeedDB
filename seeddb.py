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
        ret = {'data': []}
        with sqlite3.connect('./db/seed.db') as conn:
            conn.row_factory = sqlite3.Row
            curs = conn.cursor()
            curs.execute('SELECT * FROM ViewSeedList2;')
            res = curs.fetchall()
            ret['data'] = res
        return ret
    
    @cherrypy.expose
    def editpackets(self, variety_id):
        with sqlite3.connect('./db/seed.db') as conn:
            curs = conn.cursor()
            curs.execute('SELECT id_seed_group, seed_group FROM SeedGroups;')
            seedtypes = curs.fetchall()
            curs.execute('SELECT id_seed_variety, seed_variety_name FROM Seeds;')
            varieties = curs.fetchall()
            curs.execute("""SELECT 	
                          id_seed_packet,
	                  id_seed_variety,
                          packet_code,
                          date_purchased,
	                  date_use_by,
	                  seed_count,
	                  seed_gram,
	                  packet_treatment,
	                  id_location
                        FROM SeedPackets                           
                        WHERE id_seed_variety=?""", (variety_id,))
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
                if x[2]:  # existing packet we are updating
                    conn.execute("""UPDATE SeedPackets
                                    SET id_seed_variety=?, seed_count=?
                                    WHERE id_seed_packet=?""", x)
                elif int(x[1]):  # new packed we are adding
                    conn.execute(
                        """INSERT INTO SeedPackets (id_seed_variety, seed_count)
                             VALUES(?,?)""", x[0:2])                
                    
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
            'tools.staticdir.dir': './static'
        }
    }

    
    # Register the Mako plugin
    from makoplugin import MakoTemplatePlugin
    MakoTemplatePlugin(cherrypy.engine, base_dir=os.path.join(os.getcwd(), 'templates')).subscribe()

    # Register the Mako tool
    from makotool import MakoTool
    cherrypy.tools.template = MakoTool()
    cherrypy.quickstart(SeedDb(), '', conf)

