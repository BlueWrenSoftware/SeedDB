import cherrypy
import os

class SeedDb(object):
    @cherrypy.expose
    def index(self):
        return """
<!doctype html>
<html lang="en-au" dir="ltr">

<head>
	<title>Seed DB</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<meta name="description" content="Seed Data Base">
	<meta name="author" content="Dirk Koudstaal">
	<meta name="keywords" content="Relational DB, Seed DB, Farm Records">
	<link rel="stylesheet" href="/static/styles/styles.css">
</head>

<body>
<div id="wrapper">

<!-- Menu settings -->
		<section id="openMenu">
			<img class="right" src="/static/images/hamburger_icon.svg" >
			<div class="mainMenu">
				<img class="right" src="/static/images/hamburger_active.svg" >
				<nav class="mainDoc">
					<ul>
						<li><a href="/index">Home Page</a></li>
						<li><a href="/seedlist">Seed Collection</a></li>
						<li><a href="#">Contents</a></li>
						<li><a href="#">Contents</a></li>
						<li><a href="#">Contents</a></li>
					</ul>
				</nav>
			</div>
		</section>
<!-- End menu settings -->

	<section id="pageHeader">
		<img class="icon" src="/static/images/bettong-june.svg" height="42">
		<header id="pageHeader">
			<h1>
				Seed Data Base
			</h1>
		</header>
	</section>

	<section>	
		<header class="centerText">
			<h2>
				Seed Data Base Entries 
			</h2>
		</header>
		<article>
			<h3>Data Base Architecture</h3>
			<p>To see the full diagram click on the thumbnail.</p>
			<figure>
				<a href="/static/images/er_seed_db_v2.png" target="_blank" title="Click to open image">
					<img src="/static/images/er_seed_db_v2.png" width="100">
				</a>
			</figure>
		</article>
		<h3>
			View Records
		</h3>
		<nav  class="index">
			<ul>
				<li><a href="/seedlist">Seeds collection in store</a></li>
				<li><a href="">Seeds planted in the current season</a></li>
				<li><a href="">Overview </a></li>
				<li><a href="#acknowledge">Acknowledgements</a></li>
			</ul>
		</nav>
	</section>



	<script src="/static/js/menu.js"></script>
	<script src="/static/js/to_top.js"></script>
	
</div>
</body>

</html>
"""
    @cherrypy.expose
    def seedlist(self):
        return """
<!doctype html>
<html lang="en-au" dir="ltr">

<head>
	<title>Seed DB</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
	<meta name="description" content="Seed Data Base">
	<meta name="author" content="Dirk Koudstaal">
	<meta name="keywords" content="Relational DB, Seed DB, Farm Records">
	<link rel="stylesheet" href="/static/styles/styles.css">
</head>

<body>
<div id="wrapper">

<!-- Menu settings -->
		<section id="openMenu">
			<img class="right" src="/static/images/hamburger_icon.svg" >
			<div class="mainMenu">
				<img class="right" src="/static/images/hamburger_active.svg" >
				<nav class="mainDoc">
					<ul>
						<li><a href="/index">Home Page</a></li>
						<li><a href="/seedlist">Seed Collection</a></li>
						<li><a href="#">Contents</a></li>
						<li><a href="#">Contents</a></li>
						<li><a href="#">Contents</a></li>
					</ul>
				</nav>
			</div>
		</section>
<!-- End menu settings -->

	<section id="pageHeader">
		<img class="icon" src="/static/images/bettong-june.svg" height="42">
		<header id="pageHeader">
			<h1>
				Seed Data Base
			</h1>
		</header>
	</section>

	<section>	
		<header class="centerText">
			<h2>
				Seed Collection 
			</h2>
		</header>
		<h3>
			Table of Records
		</h3>
		<table>
			<caption>List of Seeds in Store</caption>
			<tr><th>Seed Type ID</th><th>Seed Type Name</th><th>Seed ID</th><th>Seed Variety Name</th><th>Total Seed Count</th><th>Total Seed Gram</th></tr>
			<tr><td>data</td><td>data</td><td>data</td><td>data</td><td>data</td><td>data</td></tr>
		</table>
		
	</section>



	<script src="/static/js/menu.js"></script>
	<script src="/static/js/to_top.js"></script>
	
</div>
</body>

</html>
"""

    
if __name__ == '__main__':
    conf = {
        '/': {
            'tools.sessions.on': True,
            'tools.staticdir.root': os.path.abspath(os.getcwd())
        },
        '/static': {
            'tools.staticdir.on': True,
            'tools.staticdir.dir': './public'
        }
    }
    
    cherrypy.quickstart(SeedDb(), '/', conf)
