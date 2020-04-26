/*function colNumber() {
  var number;
  number = document.getElementById("test").cellIndex;
  return number;
}

col = colNumber()*/

function searchFunction(col) {
  var input, filter, table, tr, td, i, txtValue, col;
  input = document.getElementById("searchInput");
  filter = input.value.toUpperCase();
  table = document.getElementById("searchTable");
  tr = table.getElementsByTagName("tr");
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[col];
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }       
  }
}

/*function dialogPosition() {
  tr = document.getElementsByTagName("tr");
  tr.style.display = "none";
}*/
   function toggle(){
        var off=document.getElementById('searchTable');
        if (off.style.display == "none") {
            off.style.display = "block";
        } else {
            off.style.display = "none";
        }        
    }