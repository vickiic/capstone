import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

import Login from './components/Login';
import Header from './components/Header';
import Stats1 from './components/Stats1';
import Stats2 from './components/Stats2';

class App extends Component {
  state = {
    token: "",
    username: '',
    password: '',
    nav1: false,
    nav2: false,
  }

  updateUsername = (e) => {
    this.setState({
        username: e.target.value
    });
  }

  updatePassword = (e) => {
      this.setState({
          password: e.target.value
      })
  }

  submit = () => {
      if(this.state.username === "admin"){
        this.setState({
            token: "12ks2ka23",
        })
      }
  }

  nav1 = () => {
    this.setState({
      nav1: true,
      nav2: false,
    })
  }

  nav2 = () => {
    this.setState({
      nav1: false,
      nav2: true,
    })
  }

  logout = () => {
    this.setState({
      token: '',
      username: '',
      password: '',
    })
  }

  render() {
    if(!this.state.token)
      return (
        <Login
          username={this.state.username}
          password={this.state.password}
          updateUsername={this.updateUsername}
          updatePassword={this.updatePassword}
          submit={this.submit}
        />
      )

    return (
      <div>
        <Header
          nav1={this.nav1}
          nav2={this.nav2}
          username={this.state.username}
          logout={this.logout}
        />
        {this.state.nav1 && <Stats1/>}
        {this.state.nav2 && <Stats2/>}
      </div>
    )
  }
}

export default App;
