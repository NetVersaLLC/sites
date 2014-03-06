for(var span in document.getElementsByClassName('Sb')) { 
    if(fave.exec(span.textContent)){ 
      fave.click(); 
      return true; 
    }
  }
  return false;"

