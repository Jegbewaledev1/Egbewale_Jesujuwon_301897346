// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("appointment_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("appointment_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "appointment_booked",
                    "appointment_rescheduled"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "appointment"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("appointment_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "appointment_booked",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "appointment",
            "key": {
                "id": 400
            },
            "snapshot": {
                "id": 400,
                "patient_id": 200,
                "clinician_id": 300,
                "clinic_id": 100,
                "starts_at": "2026-11-13T09:00:00Z",
                "ends_at": "2026-11-13T09:30:00Z",
                "status": "booked",
                "reason": "Routine checkup"
            }
        },
        "embedded": {
            "patient": [
                {
                    "key": {
                        "id": 200
                    },
                    "snapshot": {
                        "id": 200,
                        "synthetic_patient_no": "SYN-P-200",
                        "full_name": "Avery Morgan",
                        "date_of_birth": "1988-04-12"
                    },
                    "via": [
                        "appointment.patient_id → patient"
                    ]
                }
            ],
            "clinician": [
                {
                    "key": {
                        "id": 300
                    },
                    "snapshot": {
                        "id": 300,
                        "license_no": "SYN-L-300",
                        "full_name": "Jordan Lee",
                        "specialty": "Family Medicine"
                    },
                    "via": [
                        "appointment.clinician_id → clinician"
                    ]
                }
            ],
            "clinic": [
                {
                    "key": {
                        "id": 100
                    },
                    "snapshot": {
                        "id": 100,
                        "name": "Northside Clinic",
                        "city": "Portland"
                    },
                    "via": [
                        "appointment.clinic_id → clinic"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "appointment_rescheduled",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "appointment",
            "key": {
                "id": 400
            },
            "snapshot": {
                "id": 400,
                "patient_id": 200,
                "clinician_id": 300,
                "clinic_id": 100,
                "starts_at": "2026-11-13T09:00:00Z",
                "ends_at": "2026-11-13T09:30:00Z",
                "status": "booked",
                "reason": "Routine checkup"
            }
        },
        "embedded": {
            "patient": [
                {
                    "key": {
                        "id": 200
                    },
                    "snapshot": {
                        "id": 200,
                        "synthetic_patient_no": "SYN-P-200",
                        "full_name": "Avery Morgan",
                        "date_of_birth": "1988-04-12"
                    },
                    "via": [
                        "appointment.patient_id → patient"
                    ]
                }
            ],
            "clinician": [
                {
                    "key": {
                        "id": 300
                    },
                    "snapshot": {
                        "id": 300,
                        "license_no": "SYN-L-300",
                        "full_name": "Jordan Lee",
                        "specialty": "Family Medicine"
                    },
                    "via": [
                        "appointment.clinician_id → clinician"
                    ]
                }
            ],
            "clinic": [
                {
                    "key": {
                        "id": 100
                    },
                    "snapshot": {
                        "id": 100,
                        "name": "Northside Clinic",
                        "city": "Portland"
                    },
                    "via": [
                        "appointment.clinic_id → clinic"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "appointment",
                    "key": {
                        "id": 400
                    },
                    "field": "reason",
                    "value": "Routine checkup"
                }
            ],
            "examples": {
                "previous_start": "illustrative previous_start",
                "cancellation_code": "illustrative cancellation_code",
                "change_note": "illustrative change_note"
            }
        }
    }
]));
  await db.getCollection("appointment_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("appointment_events").find({"eventType":"appointment_booked"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("appointment_events").find({"source.key.id":400}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("appointment_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("appointment_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("appointment_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "appointment_booked",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "appointment",
        "key": {
            "id": 400
        },
        "snapshot": {
            "id": 400,
            "patient_id": 200,
            "clinician_id": 300,
            "clinic_id": 100,
            "starts_at": "2026-11-13T09:00:00Z",
            "ends_at": "2026-11-13T09:30:00Z",
            "status": "booked",
            "reason": "Routine checkup"
        }
    },
    "embedded": {
        "patient": [
            {
                "key": {
                    "id": 200
                },
                "snapshot": {
                    "id": 200,
                    "synthetic_patient_no": "SYN-P-200",
                    "full_name": "Avery Morgan",
                    "date_of_birth": "1988-04-12"
                },
                "via": [
                    "appointment.patient_id → patient"
                ]
            }
        ],
        "clinician": [
            {
                "key": {
                    "id": 300
                },
                "snapshot": {
                    "id": 300,
                    "license_no": "SYN-L-300",
                    "full_name": "Jordan Lee",
                    "specialty": "Family Medicine"
                },
                "via": [
                    "appointment.clinician_id → clinician"
                ]
            }
        ],
        "clinic": [
            {
                "key": {
                    "id": 100
                },
                "snapshot": {
                    "id": 100,
                    "name": "Northside Clinic",
                    "city": "Portland"
                },
                "via": [
                    "appointment.clinic_id → clinic"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("appointment_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "appointment_booked",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "appointment",
        "key": {
            "id": 400
        },
        "snapshot": {
            "id": 400,
            "patient_id": 200,
            "clinician_id": 300,
            "clinic_id": 100,
            "starts_at": "2026-11-13T09:00:00Z",
            "ends_at": "2026-11-13T09:30:00Z",
            "status": "booked",
            "reason": "Routine checkup"
        }
    },
    "embedded": {
        "patient": [
            {
                "key": {
                    "id": 200
                },
                "snapshot": {
                    "id": 200,
                    "synthetic_patient_no": "SYN-P-200",
                    "full_name": "Avery Morgan",
                    "date_of_birth": "1988-04-12"
                },
                "via": [
                    "appointment.patient_id → patient"
                ]
            }
        ],
        "clinician": [
            {
                "key": {
                    "id": 300
                },
                "snapshot": {
                    "id": 300,
                    "license_no": "SYN-L-300",
                    "full_name": "Jordan Lee",
                    "specialty": "Family Medicine"
                },
                "via": [
                    "appointment.clinician_id → clinician"
                ]
            }
        ],
        "clinic": [
            {
                "key": {
                    "id": 100
                },
                "snapshot": {
                    "id": 100,
                    "name": "Northside Clinic",
                    "city": "Portland"
                },
                "via": [
                    "appointment.clinic_id → clinic"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("appointment_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
