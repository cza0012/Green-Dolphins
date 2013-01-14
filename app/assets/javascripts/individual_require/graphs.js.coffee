jQuery ->
  Morris.Line
    element: 'queston_answer_chart'
    data: $('#queston_answer_chart').data('answers-questions')
    xkey: 'created_at'
    ykeys: ['total_answers','total_questions']
    labels: ['Total answers', 'Total questions']
  Morris.Donut
    element: 'user_activities'
    data: $('#user_activities').data('activities')