import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

import Home from './components/Home';
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

  home = () => {
    this.setState({
      home: true,
      nav1: false,
      nav2: false,
    })
  }

  nav1 = () => {
    this.setState({
      home: false,
      nav1: true,
      nav2: false,
    })
  }

  nav2 = () => {
    this.setState({
      home: false,
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
          home={this.home}
          username={this.state.username}
          logout={this.logout}
        />
        {this.state.home && <Home/>}
        {this.state.nav1 && <Stats1/>}
        {this.state.nav2 && <Stats2/>}
      </div>
    )
  }
}

export default App;
