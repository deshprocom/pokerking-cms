$ ->
  window.HomepageEvent =
    bindFormEvents: ->
      @bindSuccessCallback();
      @SourceTypeSelect();

    SourceTypeSelect: ->
      $("select.trigger_search_form").on "change", (e) ->
        switch this.value
          when 'info'
            $('div.infos').show();
            $('#btn_search_infos').click();
            $('#input_search_infos').focus();
          else
            $('div.infos').hide();

    bindSuccessCallback: ->
      that = @
      $('.search_infos_form').on 'ajax:success', (e, data) ->
        $('.infos tbody tr').remove();
        $(that.createInfos(data)).appendTo('.infos tbody')
        that.sourceClick();

    sourceClick: ->
      $('.sources tbody tr').on 'click', (e) ->
        id = $(this).data('id')
#        title = $(this).data('title')
        title = $(this).find('.title').text()
        $('input.source_id').val(id)
        $('input.source_title').val(title)

    createInfos: (infos) ->
      if infos.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for info in infos
        trs += "<tr data-id=#{info.id} data-type='info'>"
        trs += "<td>#{info.id}</td>"
        trs += "<td class='title'>#{info.title}</td>"
        trs += '/<tr>'
      trs