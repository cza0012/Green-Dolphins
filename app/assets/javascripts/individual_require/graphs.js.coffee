jQuery ->
  Morris.Line
    element: 'queston_answer_chart'
    data: $('#queston_answer_chart').data('answers')
    xkey: 'created_at'
    ykeys: ['total_answers','total_questions']
    labels: ['Total answers', 'Total questions']