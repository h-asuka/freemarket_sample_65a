$(function(){
  $('.price_calc').on('input', function(){
    var data = $('.price_calc').val();
    var profit = Math.round(data * 0.9)
    var fee = (data - profit)
    $('.value_1').html(fee)
    $('.value_1').prepend('¥')
    $('.value_2').html(profit)
    $('.value_2').prepend('¥')
    $('#price').val(profit)
    if(profit == '') {
    $('.value_2').html('');
    $('.value_1').html('');
    }
  })
});