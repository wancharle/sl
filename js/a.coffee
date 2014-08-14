
class A

  constructor: ->
    @teste = 2
    b = new B()
    $("#teste").html(b.getTeste())
  
window.A = A

$ ->
  new A();
# vim: set ts=2 sw=2 sts=2 expandtab:

