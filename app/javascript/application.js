// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "popper"
import "bootstrap"

$('.alert-dismissible .close').on('click', function(){
    $(this).parent().hide();
  });
  