function openGraph(evt, graphName){
    var i, tabcontent, tablinks;
//    alert(graphName);
    tabcontent = document.getElementsByClassName("tabcontent");
    if (graphName == "Warnings") {
        tabcontent[2].style.display = "block";
        tabcontent[1].style.display = "none";
        tabcontent[0].style.display = "none";
        tabcontent[3].style.display = "none";
    }
    if (graphName == "Main"){
        tabcontent[0].style.display = "block";
        tabcontent[1].style.display = "none";
        tabcontent[2].style.display = "none";
        tabcontent[3].style.display = "none";
    }
    if (graphName == "Outliers"){
        tabcontent[1].style.display = "block";
        tabcontent[0].style.display = "none";
        tabcontent[2].style.display = "none";
        tabcontent[3].style.display = "none";
    }
    if (graphName == "Live"){
        tabcontent[3].style.display = "block";
        tabcontent[0].style.display = "none";
        tabcontent[1].style.display = "none";
        tabcontent[2].style.display = "none";
    }
/*    for (i = 0; i <tabcontent.length; i++) {
        tabcontent[i].getElementsByClassName.display = "none";
    }
*/
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    document.getElementById(graphName).style.display = "block";
    evt.currentTarget.className += " active";
}

