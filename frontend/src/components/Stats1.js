import React, { Component } from 'react';
//import axios from 'axios';
import api from '../resources/Credentials';
import * as axios from '../stubs/axios'
import { Dropdown, DropdownToggle, DropdownMenu, DropdownItem } from 'reactstrap';

export default class Stats1 extends Component {
    state = {
        chosenDeviceType: "",
        deviceTypes: [],
        devices: [],
        dropdownOpen: false,
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
        axios.get(`https://devices.intouchhealth.com/api/v1/device_types`, config)
        .then(res => {
            this.setState(
                {
                    chosenDeviceType: res.device_types[0].name,
                    deviceTypes: res.device_types,
                }, () => {
                    let config = {
                        headers: {
                            'crossDomain': true,
                            "ITH-Username": api.username,
                            "ITH-API-Key": api.key,
                            "ITH-Device-Type": this.state.chosenDeviceType,
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
            )
        })

    }

    toggle = () => {
        this.setState({
            dropdownOpen: !this.state.dropdownOpen,
        })
    }

    selectDeviceType = (deviceType) => {
        this.setState({
            chosenDeviceType: deviceType,
        })

        let config = {
            headers: {
                'crossDomain': true,
                "ITH-Username": api.username,
                "ITH-API-Key": api.key,
                "ITH-Device-Type": deviceType,
                "Content-Type": "application/json"
            }
        }
        console.log(config)
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
                <Dropdown isOpen={this.state.dropdownOpen} toggle={this.toggle}>
                    <DropdownToggle caret>
                        Device Types
                    </DropdownToggle>
                    <DropdownMenu>
                        {this.state.deviceTypes.map(deviceType => {
                            return (<DropdownItem onClick={() => this.selectDeviceType(deviceType.name)}>{deviceType.name}</DropdownItem>)
                        })}
                    </DropdownMenu>
                </Dropdown>
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
