# classe responsavel pela visualizacao da aba opcoes

class TabOpcoes
  constructor: (config)->
    @config = config
    @popup = Popup.getIS(config)
    @dados = Dados.getIS(config)

    @form = new FormOpcoes(config)

  load: ()->
   @form.render()
   console.log 'TabOpcoes carregado'

  

# vim: set ts=2 sw=2 sts=2 expandtab:

