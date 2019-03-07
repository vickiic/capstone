$(document).on('turbolinks:load', function() {
// Initialize Firebase
var config = {
    apiKey: "AIzaSyB6d0eWLz0Ury0nKI-Fs7cvlrTyZ8llMdI",
    authDomain: "ithfrontend-d0aa2.firebaseapp.com",
    databaseURL: "https://ithfrontend-d0aa2.firebaseio.com",
    projectId: "ithfrontend-d0aa2",
    storageBucket: "ithfrontend-d0aa2.appspot.com",
    messagingSenderId: "513072734313"
  };
  firebase.initializeApp(config);
// Firebase Database Reference and the child
var dbRef = firebase.database().ref();
var usersRef = dbRef.child('chats');

readUserData(); 

var userListUIOnce = document.getElementById("user-list-once");
userListUIOnce.innerHTML = "123456"
usersRef.once("value", function(snapshot) {
  userListUIOnce.innerHTML = ""
  snapshot.forEach(function(child) {
    userListUIOnce.innerHTML =  userListUIOnce.innerHTML + child.key+ ',' + child.val().name+'<br>';
    console.log(child.key+": "+child.val());
  });
});

createChat();
// --------------------------
// READ
// --------------------------
function readUserData() {

	var userListUI = document.getElementById("user-list");

	usersRef.on("value", snap => {

		userListUI.innerHTML = ""

		snap.forEach(childSnap => {

			let key = childSnap.key,
				value = childSnap.val()
  			
			let $li = document.createElement("li");

			// edit icon
			let editIconUI = document.createElement("span");
			editIconUI.class = "edit-user";
			editIconUI.innerHTML = " ✎";
			editIconUI.setAttribute("userid", key);
			editIconUI.addEventListener("click", editButtonClicked)

			// delete icon
			let deleteIconUI = document.createElement("span");
			deleteIconUI.class = "delete-user";
			deleteIconUI.innerHTML = " ☓";
			deleteIconUI.setAttribute("userid", key);
			deleteIconUI.addEventListener("click", deleteButtonClicked)
			
			$li.innerHTML = value.name;
			$li.append(editIconUI);
			$li.append(deleteIconUI);

			$li.setAttribute("user-key", key);
			$li.addEventListener("click", userClicked)
			userListUI.append($li);

 		});


	})

}



function userClicked(e) {


		var userID = e.target.getAttribute("user-key");

		var userRef = dbRef.child('chats/' + userID);
		var userDetailUI = document.getElementById("user-detail");

		userRef.on("value", snap => {

			userDetailUI.innerHTML = ""

			snap.forEach(childSnap => {
				var $p = document.createElement("p");
				$p.innerHTML = childSnap.key  + " - " +  childSnap.val();
				userDetailUI.append($p);
			})

		});
	

}





// --------------------------
// ADD
// --------------------------

var addUserBtnUI = document.getElementById("add-user-btn");
addUserBtnUI.addEventListener("click", addUserBtnClicked)
var addUserBtnUI1 = document.getElementById("add-user-btn1");
addUserBtnUI1.addEventListener("click", addUserBtnClicked)


function addUserBtnClicked() {

	var usersRef = dbRef.child('chats');

	var addUserInputsUI = document.getElementsByClassName("user-input");

 	// this object will hold the new user information
    let newUser = {};

    // loop through View to get the data for the model 
    for (let i = 0, len = addUserInputsUI.length; i < len; i++) {

        let key = addUserInputsUI[i].getAttribute('data-key');
        let value = addUserInputsUI[i].value;
        newUser[key] = value;
    }

	usersRef.push(newUser)

    
//   console.log(myPro)
   


}


// --------------------------
// DELETE
// --------------------------
function deleteButtonClicked(e) {

		e.stopPropagation();

		var userID = e.target.getAttribute("userid");

		var userRef = dbRef.child('chats/' + userID);
		
		userRef.remove();

}


// --------------------------
// EDIT
// --------------------------
function editButtonClicked(e) {
	
	document.getElementById('edit-user-module').style.display = "block";

	//set user id to the hidden input field
	document.querySelector(".edit-userid").value = e.target.getAttribute("userid");

	var userRef = dbRef.child('chats/' + e.target.getAttribute("userid"));

	// set data to the user field
	var editUserInputsUI = document.querySelectorAll(".edit-user-input");


	userRef.on("value", snap => {

		for(var i = 0, len = editUserInputsUI.length; i < len; i++) {

			var key = editUserInputsUI[i].getAttribute("data-key");
					editUserInputsUI[i].value = snap.val()[key];
		}

	});




	var saveBtn = document.querySelector("#edit-user-btn");
	saveBtn.addEventListener("click", saveUserBtnClicked)
}


function saveUserBtnClicked(e) {
 
	var userID = document.querySelector(".edit-userid").value;
	var userRef = dbRef.child('chats/' + userID);

	var editedUserObject = {}

	var editUserInputsUI = document.querySelectorAll(".edit-user-input");

	editUserInputsUI.forEach(function(textField) {
		let key = textField.getAttribute("data-key");
		let value = textField.value;
  		editedUserObject[textField.getAttribute("data-key")] = textField.value
	});



	userRef.update(editedUserObject);

	document.getElementById('edit-user-module').style.display = "none";

}

//const userListUI = document.getElementById("chat-list");
function createChat() {

	var userListUI = document.getElementById("chat-list");
	usersRef.on("value", snap => {

		userListUI.innerHTML = "";
/*				var incoming_message = document.createElement('div');
				userListUI.appendChild(incoming_message);
				incoming_message.innerHTML="<p>Incoming message</p>";
				incoming_message.className = "incoming_msg";
				var outgoing_message = document.createElement('div');
				userListUI.appendChild(outgoing_message);
				outgoing_message.innerHTML="<p>Outgoing message</p>";
				outgoing_message.className = "outgoing_msg";
*/
		snap.forEach(childSnap => {

			let key = childSnap.key,
			value = childSnap.val()
  			
//			let $li = document.createElement("li");
			let $div = document.createElement("div");
			if(value.sender_id != "physcid1") {
				$div.className="col-4"
				$div.innerHTML = "<p><font size=\"4\" color=\"cyan\">" + value.text +"</font></p>";
			}
			else {
				$div.className="col-4 offset-6"
				$div.innerHTML = "<p><font size=\"4\" color=\"red\">"+value.text+"</font></p>";
			}
/*
			$li.setAttribute("user-key", key);
			$li.addEventListener("click", userClicked)
*/
			userListUI.appendChild($div);

 		});
		// auto scroll  y axis to the bottom
		var objDiv = document.getElementById("msg_history");
		objDiv.scrollTop = objDiv.scrollHeight;

	})

}




        
});





