import React, { Component } from 'react';

export default class Login extends Component {
    render() {
        return (
            <div>
                <input
                    type="text"
                    onChange={this.props.updateUsername}
                    value={this.props.username}
                />
                <br/>
                <input
                    type="password"
                    onChange={this.props.updatePassword}
                    value={this.props.password}
                />
                <br/>
                {this.props.username}
                <br/>
                {this.props.password}
                <br/>
                <button
                    onClick={this.props.submit}
                > submit
                </button>
            </div>
        )
    }
}
