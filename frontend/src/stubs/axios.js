export function get(url, config){
    switch(url){
        case `https://devices.intouchhealth.com/api/v1/authenticate`:
            return new Promise((resolve, reject)=> {
                resolve(
                    {
                        "success": true
                    }
                )
            })
        case `https://devices.intouchhealth.com/api/v1/device_types`:
            return new Promise((resolve, reject)=> {
                resolve(
                    {
                        "success": true,
                        "device_types": [
                            {
                                "id": 1,
                                "name": "testing",
                                "created_at": "2017-12-01T22:02:23.000Z",
                                "updated_at": "2017-12-01T18:25:34.000Z"
                            },
                            {
                                "id": 2,
                                "name": "Example2",
                                "created_at": "2017-12-01T22:02:23.000Z",
                                "updated_at": "2017-12-01T18:25:34.000Z"
                            }
                        ]
                    }
                )
            })
        case `https://devices.intouchhealth.com/api/v1/devices`:
            switch(config.headers["ITH-Device-Type"]){
                case "testing":
                    return new Promise((resolve, reject)=> {
                        resolve(
                            {
                                "success": true,
                                "devices": [
                                    {
                                        "id": 182,
                                        "name": "testing",
                                        "created_at": "2018-10-22T18:50:19.000Z",
                                        "updated_at": "2018-10-22T18:50:19.000Z",
                                        "device_type_id": 9,
                                        "device_uid": "6ea1f358-2499-4a03-8689-36zza17dc627",
                                        "is_enabled": true
                                    },
                                    {
                                        "id": 183,
                                        "name": "testing",
                                        "created_at": "2018-10-22T19:17:09.000Z",
                                        "updated_at": "2018-10-22T19:17:09.000Z",
                                        "device_type_id": 9,
                                        "device_uid": "933ff8a1-4ad3-4582-9185-7b0152c72d65",
                                        "is_enabled": true
                                    },
                                    {
                                        "id": 187,
                                        "name": "testing_new",
                                        "created_at": "2018-10-26T00:18:04.000Z",
                                        "updated_at": "2018-10-26T00:18:04.000Z",
                                        "device_type_id": 9,
                                        "device_uid": "5e3036db-4a46-4914-8179-42c386da0f37",
                                        "is_enabled": true
                                    },
                                    {
                                        "id": 189,
                                        "name": "testing_new2",
                                        "created_at": "2018-10-26T20:15:06.000Z",
                                        "updated_at": "2018-10-26T20:15:06.000Z",
                                        "device_type_id": 9,
                                        "device_uid": "ccb53ec5-cb64-4de4-bdd0-9bdc6e331683",
                                        "is_enabled": true
                                    }
                                ]
                            }
                        )
                    })
                case "Example2":
                    return new Promise((resolve, reject)=> {
                        resolve(
                            {
                                "success": true,
                                "devices": [
                                    {
                                        "id": 182,
                                        "name": "David's IphoneX",
                                        "created_at": "2018-10-22T18:50:19.000Z",
                                        "updated_at": "2018-10-22T18:50:19.000Z",
                                        "device_type_id": 9,
                                        "device_uid": "6ea1f358-2499-4a03-8689-36zza17dc627",
                                        "is_enabled": true
                                    },
                                    {
                                        "id": 183,
                                        "name": "David's Samsung Galaxy S10",
                                        "created_at": "2018-10-22T19:17:09.000Z",
                                        "updated_at": "2018-10-22T19:17:09.000Z",
                                        "device_type_id": 9,
                                        "device_uid": "933ff8a1-4ad3-4582-9185-7b0152c72d65",
                                        "is_enabled": true
                                    },
                                ]
                            }
                        )
                    })
                default: alert("Something went wrong 1")
            }
            break;
        default: alert("Something went wrong 2")
    }
}
