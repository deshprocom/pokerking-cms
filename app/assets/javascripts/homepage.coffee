$ ->
  window.HomepageEvent =
    bindFormEvents: ->
      @bindSuccessCallback();
      @SourceTypeSelect();

    SourceTypeSelect: ->
      $("select.trigger_search_form").on "change", (e) ->
        switch this.value
          when 'event_info'
            $('div.event_infos').show();
            $('div.infos').hide();
            $('#btn_search_event_infos').click();
            $('#input_search_event_infos').focus();
          when 'info'
            $('div.infos').show();
            $('div.event_infos').hide();
            $('#btn_search_infos').click();
            $('#input_search_infos').focus();
          else
            $('div.infos').hide();
            $('div.event_infos').hide();

    bindSuccessCallback: ->
      that = @
      $('.search_event_infos_form').on 'ajax:success', (e, data) ->
        $('.event_infos tbody tr').remove();
        $(that.createevent_infos(data)).appendTo('.event_infos tbody')
        that.sourceClick();

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

    createevent_infos: (event_infos) ->
      if event_infos.length == 0
        trs = '<tr><td>没有相关数据</td></tr>'
      else
        trs = ''
      for event_info in event_infos
        trs += "<tr data-id=#{event_info.id} data-type='event_info'>"
        trs += "<td>#{event_info.id}</td>"
        trs += "<td class='title'>#{event_info.title}</td>"
        trs += '/<tr>'
      trs

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