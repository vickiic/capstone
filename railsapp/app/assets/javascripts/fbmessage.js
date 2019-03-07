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
	const dbRef = firebase.database().ref();
	const usersRef = dbRef.child('chats');
	
	readUserData(); 
	
	const userListUIOnce = document.getElementById("user-list-once");
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
	
		const userListUI = document.getElementById("user-list");
	
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
	
			const userRef = dbRef.child('chats/' + userID);
			const userDetailUI = document.getElementById("user-detail");
	
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
	
	const addUserBtnUI = document.getElementById("add-user-btn");
	addUserBtnUI.addEventListener("click",  addUserBtnClicked);
	const addUserBtnUI1 = document.getElementById("add-user-btn1");
	addUserBtnUI1.addEventListener("click", addUserBtnClicked)
	
	
	function addUserBtnClicked() {
	
		const usersRef = dbRef.child('chats');
	
		const addUserInputsUI = document.getElementsByClassName("user-input");
	
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
	
			const userRef = dbRef.child('chats/' + userID);
			
			userRef.remove();
	
	}
	
	
	// --------------------------
	// EDIT
	// --------------------------
	function editButtonClicked(e) {
		
		document.getElementById('edit-user-module').style.display = "block";
	
		//set user id to the hidden input field
		document.querySelector(".edit-userid").value = e.target.getAttribute("userid");
	
		const userRef = dbRef.child('chats/' + e.target.getAttribute("userid"));
	
		// set data to the user field
		const editUserInputsUI = document.querySelectorAll(".edit-user-input");
	
	
		userRef.on("value", snap => {
	
			for(var i = 0, len = editUserInputsUI.length; i < len; i++) {
	
				var key = editUserInputsUI[i].getAttribute("data-key");
						editUserInputsUI[i].value = snap.val()[key];
			}
	
		});
	
	
	
	
		const saveBtn = document.querySelector("#edit-user-btn");
		saveBtn.addEventListener("click", saveUserBtnClicked)
	}
	
	
	function saveUserBtnClicked(e) {
	 
		const userID = document.querySelector(".edit-userid").value;
		const userRef = dbRef.child('chats/' + userID);
	
		var editedUserObject = {}
	
		const editUserInputsUI = document.querySelectorAll(".edit-user-input");
	
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
	
		const userListUI = document.getElementById("chat-list");
	//	alert("OK");
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
				let $div1 = document.createElement("div");
				let $div2 = document.createElement("div");
				let $div3 = document.createElement("div");
				if(value.sender_id != "physcid1") {
					$div1.className="incoming_msg"
					$div2.className="received_msg"
					$div3.className="received_withd_msg"
					$div1.appendChild($div2)
					$div2.appendChild($div3)
					$div3.innerHTML = "<p>"+ value.text +"</p>";
				}
				else {
					$div1.className="outgoing_msg"
					$div2.className="sent_msg"
					$div1.appendChild($div2)
					$div2.innerHTML = "<p>"+ value.text +"</p>";
				}
	/*
				$li.setAttribute("user-key", key);
				$li.addEventListener("click", userClicked)
	*/
				userListUI.appendChild($div1);
	
			 });
			// auto scroll  y axis to the bottom
			var objDiv = document.getElementById("msg_history");
			objDiv.scrollTop = objDiv.scrollHeight;
	
		})
	
	}
	
	
	
	
					
	});