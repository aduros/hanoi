#!/usr/bin/env python

FLAMBE_DIR = "../flambe"

def options(ctx):
    ctx.load("flambe", tooldir=FLAMBE_DIR+"/tools")

def configure(ctx):
    ctx.load("flambe", tooldir=FLAMBE_DIR+"/tools")

def build(ctx):
    ctx(features="flambe", main="ninja.ClientMain")
