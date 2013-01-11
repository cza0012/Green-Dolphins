jQuery ->
  Morris.Line
    element: 'queston_answer_chart'
    data: $('#queston_answer_chart').data('answers')
    xkey: 'created_at'
    ykeys: ['total']
    labels: ['Total answers']