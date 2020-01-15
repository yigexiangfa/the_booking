$('#time_plan_time_list_id').dropdown({
  onChange: function(value, text, $selectedItem){
    var repeat_url = new URL(this.form.action)
    repeat_url.pathname += '/calendar'
    repeat_url.searchParams.set('time_list_id', value)
    repeat_url.searchParams.set('repeat_type', document.getElementById('time_plan_repeat_type').value)

    Rails.ajax({url: repeat_url, type: 'GET', dataType: 'script'})
  }
})
$('#time_plan_repeat_type').dropdown({
  onChange: function(value, text, $selectedItem){
    var repeat_url = new URL(this.form.action)
    repeat_url.pathname += '/calendar'
    repeat_url.searchParams.set('repeat_type', value)
    repeat_url.searchParams.set('time_list_id', document.getElementById('time_plan_time_list_id').value)

    Rails.ajax({url: repeat_url, type: 'GET', dataType: 'script'})
  }
})
