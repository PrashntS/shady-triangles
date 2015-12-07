#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#.--. .-. ... .... -. - ... .-.-.- .. -.

import click

from flask.ext.script import Manager
from shady import create_app, app

manager = Manager(app)

@manager.command
def runserver():
  "Runs the App"
  create_app()
  app.run(host     = app.config['SERVE_HOST'],
          port     = app.config['SERVE_PORT'],
          threaded = app.config['THREADED'])

if __name__ == "__main__":
  manager.run()
