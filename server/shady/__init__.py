#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#.--. .-. ... .... -. - ... .-.-.- .. -.

from flask import Flask, render_template, g, request, jsonify

app = Flask(__name__)
app.config.from_pyfile('config.py')

def create_app():
  @app.before_request
  def do_important_stuff():
    return

  @app.after_request
  def do_more_important_stuff(response):
    return response

  @app.errorhandler(500)
  def handle_internal_server_error(e):
    dat = {
      'error_code': 500,
      'error_msg': str(e),
      'error_dsc': None
    }
    return jsonify(dat), 500

  @app.errorhandler(404)
  def handle_not_found_error(e):
    dat = {
      'error_code': 404,
      'error_msg': str(e),
      'error_dsc': None
    }
    return jsonify(dat), 404

  @app.route('/')
  def home():
    return "Works!"

if __name__ == '__main__':
  create_app()
