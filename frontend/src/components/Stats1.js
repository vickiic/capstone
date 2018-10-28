import React, { Component } from 'react';
//import axios from 'axios';
import api from '../resources/Credentials';
import * as axios from '../stubs/axios'

export default class Stats1 extends Component {
    state = {
        devices: [],
    }


    componentDidMount(){
        let config = {
            headers: {
                'crossDomain': true,
                "ITH-Username": api.username,
                "ITH-API-Key": api.key,
                "Content-Type": "application/json"
            }
        }
        console.log(config)
        axios.foo();
        axios.get(`https://devices.intouchhealth.com/api/v1/devices`, config)
        .then(res => {
            console.log("here")
            console.log(res)
        })
    }

    render(){
        return(
            <div>
                Some stats!
            </div>
        )
    }
}
