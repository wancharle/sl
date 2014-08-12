
class A

  constructor: ->
    @teste = 2
    console.log('teste');
    b = new B()
    console.log('teste');
    $("#teste").html(b.getTeste())
  
window.A = A
# vim: set ts=2 sw=2 sts=2 expandtab:

