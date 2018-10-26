import React, { Component } from 'react';

export default class Header extends Component {
    render() {
        return (
            <div>
                Hello {this.props.username}!
                <button onClick={this.props.home}>Home</button>
                <button onClick={this.props.nav1}>Show stats!</button>
                <button onClick={this.props.nav2}>Show different stats!</button>
                <button onClick={this.props.logout}>Logout</button>
                <br/>
                <br/>
            </div>
        )
    }
}
