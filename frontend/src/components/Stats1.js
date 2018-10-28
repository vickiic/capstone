import React, { Component } from 'react';
//import axios from 'axios';
import api from '../resources/Credentials';
import * as axios from '../stubs/axios'

export default class Stats1 extends Component {
    state = {
        devices: [],
        search: "",
    }

    updateSearch = (event) => this.setState({search: event.target.value})

    componentDidMount(){
        let config = {
            headers: {
                'crossDomain': true,
                "ITH-Username": api.username,
                "ITH-API-Key": api.key,
                "Content-Type": "application/json"
            }
        }
        axios.get(`https://devices.intouchhealth.com/api/v1/devices`, config)
        .then(res => {
            this.setState({
                devices: res.devices,
            })
        })
    }

    render(){
        return(
            <div>
                <input
                    type="text"
                    onChange={this.updateSearch}
                    value={this.state.search}

                />
                <div>
                    <span className="stats_name">Name</span>
                    <span className="stats_id">Id</span>
                    <span className="stats_enabled">Enabled</span>
                </div>

                {this.state.devices.map(device => {
                    if(device.name.includes(this.state.search)){
                        return(
                            <div>
                                <span className="stats_name">{device.name}</span>
                                <span className="stats_id">{device.id}</span>
                                <span className="stats_enabled">{device.is_enabled ? "true" : "false"}</span>
                            </div>
                        )
                    }
                })}
            </div>
        )
    }
}
