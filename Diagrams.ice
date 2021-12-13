{
  "version": "1.2",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "TinyFPGA-B2",
    "graph": {
      "blocks": [
        {
          "id": "983709ba-7116-4092-bed7-f4e6860191da",
          "type": "basic.memory",
          "data": {
            "name": "program_memory",
            "list": "",
            "local": false,
            "format": 10
          },
          "position": {
            "x": -2504,
            "y": 488
          },
          "size": {
            "width": 152,
            "height": 192
          }
        },
        {
          "id": "be77d1c8-be91-44c8-b691-aae511590ccc",
          "type": "basic.code",
          "data": {
            "code": "ImmediateExtractor",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "instruction"
                }
              ],
              "out": [
                {
                  "name": "result"
                }
              ]
            }
          },
          "position": {
            "x": -720,
            "y": 504
          },
          "size": {
            "width": 248,
            "height": 136
          }
        },
        {
          "id": "0bf3aff4-1795-4430-a72d-c5b657a82729",
          "type": "basic.code",
          "data": {
            "code": "Mux\nRegister\nWrite\nDataSource ",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "sourceSelection",
                  "range": "[1:0]",
                  "size": 2
                },
                {
                  "name": "aluResult",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "upperImmediateSignExtended",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "pcNext",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "mainMemory",
                  "range": "[31:0]",
                  "size": 32
                }
              ],
              "out": [
                {
                  "name": "resultValue",
                  "range": "[31:0]",
                  "size": 32
                }
              ]
            }
          },
          "position": {
            "x": -688,
            "y": 240
          },
          "size": {
            "width": 272,
            "height": 224
          }
        },
        {
          "id": "3efc3b79-af25-412c-8183-e72e8b33c8be",
          "type": "basic.code",
          "data": {
            "code": "ALU",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "opcode",
                  "range": "[3:0]",
                  "size": 4
                },
                {
                  "name": "left",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "right",
                  "range": "[31:0]",
                  "size": 32
                }
              ],
              "out": [
                {
                  "name": "result",
                  "range": "[31:0]",
                  "size": 32
                }
              ]
            }
          },
          "position": {
            "x": 304,
            "y": 248
          },
          "size": {
            "width": 192,
            "height": 128
          }
        },
        {
          "id": "cec87b83-6bf5-4965-b77a-1be1b4e8397c",
          "type": "basic.code",
          "data": {
            "code": "ControlUnit",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "instruction"
                }
              ],
              "out": [
                {
                  "name": "mem_write_mode"
                },
                {
                  "name": "register_write_enable"
                },
                {
                  "name": "register_write_pattern",
                  "range": "[2:0]",
                  "size": 3
                },
                {
                  "name": "aluOperationCode",
                  "range": "[3:0]",
                  "size": 4
                },
                {
                  "name": "aluRightInputSourceControl"
                },
                {
                  "name": "registerWriteSourceControl"
                },
                {
                  "name": "mem_write"
                },
                {
                  "name": "mem_write_mode"
                },
                {
                  "name": "register_write_pattern"
                }
              ]
            }
          },
          "position": {
            "x": -728,
            "y": 752
          },
          "size": {
            "width": 192,
            "height": 328
          }
        },
        {
          "id": "bde4c5b6-335d-49cb-bca6-e75774ec8a8b",
          "type": "basic.code",
          "data": {
            "code": "ALU\nRight\nInputSource",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "sourceSelection"
                },
                {
                  "name": "immediateSource"
                },
                {
                  "name": "registerSource"
                }
              ],
              "out": [
                {
                  "name": "resultValue",
                  "range": "[31:0]",
                  "size": 32
                }
              ]
            }
          },
          "position": {
            "x": -184,
            "y": 504
          },
          "size": {
            "width": 280,
            "height": 136
          }
        },
        {
          "id": "7d2f6364-28c8-4b7f-916f-146d59be46c2",
          "type": "basic.code",
          "data": {
            "code": "Register\nMemory",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "wr_data",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "wr_address"
                },
                {
                  "name": "wr_enable"
                },
                {
                  "name": "rd_address_a"
                },
                {
                  "name": "rd_address_b"
                },
                {
                  "name": "write_pattern",
                  "range": "[2:0]",
                  "size": 3
                }
              ],
              "out": [
                {
                  "name": "data_out_a",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "data_out_b",
                  "range": "[31:0]",
                  "size": 32
                }
              ]
            }
          },
          "position": {
            "x": -168,
            "y": 240
          },
          "size": {
            "width": 216,
            "height": 208
          }
        },
        {
          "id": "d6320930-d6ed-4c52-942a-d85a7407ddc6",
          "type": "basic.code",
          "data": {
            "code": "Memory",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "address",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "wr_data",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "write_length"
                },
                {
                  "name": "wr_enable"
                }
              ],
              "out": [
                {
                  "name": "read_data",
                  "range": "[31:0]",
                  "size": 32
                }
              ]
            }
          },
          "position": {
            "x": 608,
            "y": 296
          },
          "size": {
            "width": 200,
            "height": 224
          }
        },
        {
          "id": "d4b90617-521a-40a8-a7c9-5100f85e4755",
          "type": "basic.code",
          "data": {
            "code": "PCControl",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "opcode",
                  "range": "[6:0]",
                  "size": 7
                }
              ],
              "out": [
                {
                  "name": "pcSourceControl"
                }
              ]
            }
          },
          "position": {
            "x": -2000,
            "y": 808
          },
          "size": {
            "width": 192,
            "height": 128
          }
        },
        {
          "id": "728f9210-bc5b-4baa-89ff-e8e598a42547",
          "type": "basic.code",
          "data": {
            "code": "ProgramCounter",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "reset"
                },
                {
                  "name": "pc_in",
                  "range": "[31:0]",
                  "size": 32
                }
              ],
              "out": [
                {
                  "name": "pc_out",
                  "range": "[31:0]",
                  "size": 32
                }
              ]
            }
          },
          "position": {
            "x": -1248,
            "y": 928
          },
          "size": {
            "width": 248,
            "height": 136
          }
        },
        {
          "id": "11e471c1-bfeb-49ae-bbde-01c44de63759",
          "type": "basic.code",
          "data": {
            "code": "PCSourceassign pcResult=(pcSourceControl === PC_SOURCE_PC_PLUS_FOUR)? pcPlusFour : pcImmediate;",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "pcPlusFour",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "pcPlusJal",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "pcPlusBOffset",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "pcSourceControl"
                }
              ],
              "out": [
                {
                  "name": "pcResult",
                  "range": "[31:0]",
                  "size": 32
                }
              ]
            }
          },
          "position": {
            "x": -1680,
            "y": 616
          },
          "size": {
            "width": 336,
            "height": 312
          }
        },
        {
          "id": "1851b0c1-5a98-4b83-a540-1bb1415c0891",
          "type": "basic.code",
          "data": {
            "code": "PCNext",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "in",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "regDiff",
                  "range": "[31:0]",
                  "size": 32
                }
              ],
              "out": [
                {
                  "name": "pc_plus_four",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "pcPlusJal",
                  "range": "[31:0]",
                  "size": 32
                },
                {
                  "name": "pcPlusBOffset",
                  "range": "[31:0]",
                  "size": 32
                }
              ]
            }
          },
          "position": {
            "x": -2240,
            "y": 504
          },
          "size": {
            "width": 192,
            "height": 128
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "cec87b83-6bf5-4965-b77a-1be1b4e8397c",
            "port": "aluRightInputSourceControl"
          },
          "target": {
            "block": "bde4c5b6-335d-49cb-bca6-e75774ec8a8b",
            "port": "sourceSelection"
          }
        },
        {
          "source": {
            "block": "cec87b83-6bf5-4965-b77a-1be1b4e8397c",
            "port": "mem_write_mode"
          },
          "target": {
            "block": "d6320930-d6ed-4c52-942a-d85a7407ddc6",
            "port": "write_length"
          },
          "vertices": [
            {
              "x": 376,
              "y": 672
            }
          ]
        },
        {
          "source": {
            "block": "be77d1c8-be91-44c8-b691-aae511590ccc",
            "port": "result"
          },
          "target": {
            "block": "bde4c5b6-335d-49cb-bca6-e75774ec8a8b",
            "port": "immediateSource"
          }
        },
        {
          "source": {
            "block": "d6320930-d6ed-4c52-942a-d85a7407ddc6",
            "port": "read_data"
          },
          "target": {
            "block": "0bf3aff4-1795-4430-a72d-c5b657a82729",
            "port": "mainMemory"
          },
          "vertices": [
            {
              "x": -16,
              "y": 712
            },
            {
              "x": -800,
              "y": 648
            }
          ],
          "size": 32
        },
        {
          "source": {
            "block": "3efc3b79-af25-412c-8183-e72e8b33c8be",
            "port": "result"
          },
          "target": {
            "block": "d6320930-d6ed-4c52-942a-d85a7407ddc6",
            "port": "address"
          },
          "size": 32
        },
        {
          "source": {
            "block": "3efc3b79-af25-412c-8183-e72e8b33c8be",
            "port": "result"
          },
          "target": {
            "block": "0bf3aff4-1795-4430-a72d-c5b657a82729",
            "port": "aluResult"
          },
          "vertices": [
            {
              "x": -288,
              "y": 160
            },
            {
              "x": -864,
              "y": 216
            }
          ],
          "size": 32
        },
        {
          "source": {
            "block": "0bf3aff4-1795-4430-a72d-c5b657a82729",
            "port": "resultValue"
          },
          "target": {
            "block": "7d2f6364-28c8-4b7f-916f-146d59be46c2",
            "port": "wr_data"
          },
          "vertices": [
            {
              "x": -296,
              "y": 320
            }
          ],
          "size": 32
        },
        {
          "source": {
            "block": "cec87b83-6bf5-4965-b77a-1be1b4e8397c",
            "port": "register_write_pattern"
          },
          "target": {
            "block": "7d2f6364-28c8-4b7f-916f-146d59be46c2",
            "port": "write_pattern"
          },
          "vertices": [
            {
              "x": -344,
              "y": 680
            }
          ],
          "size": 3
        },
        {
          "source": {
            "block": "cec87b83-6bf5-4965-b77a-1be1b4e8397c",
            "port": "aluOperationCode"
          },
          "target": {
            "block": "3efc3b79-af25-412c-8183-e72e8b33c8be",
            "port": "opcode"
          },
          "size": 4
        },
        {
          "source": {
            "block": "bde4c5b6-335d-49cb-bca6-e75774ec8a8b",
            "port": "resultValue"
          },
          "target": {
            "block": "3efc3b79-af25-412c-8183-e72e8b33c8be",
            "port": "right"
          },
          "vertices": [
            {
              "x": 160,
              "y": 568
            }
          ],
          "size": 32
        },
        {
          "source": {
            "block": "7d2f6364-28c8-4b7f-916f-146d59be46c2",
            "port": "data_out_b"
          },
          "target": {
            "block": "3efc3b79-af25-412c-8183-e72e8b33c8be",
            "port": "left"
          },
          "vertices": [
            {
              "x": 104,
              "y": 392
            }
          ],
          "size": 32
        },
        {
          "source": {
            "block": "7d2f6364-28c8-4b7f-916f-146d59be46c2",
            "port": "data_out_a"
          },
          "target": {
            "block": "d6320930-d6ed-4c52-942a-d85a7407ddc6",
            "port": "wr_data"
          },
          "vertices": [
            {
              "x": 360,
              "y": 432
            }
          ],
          "size": 32
        },
        {
          "source": {
            "block": "d4b90617-521a-40a8-a7c9-5100f85e4755",
            "port": "pcSourceControl"
          },
          "target": {
            "block": "11e471c1-bfeb-49ae-bbde-01c44de63759",
            "port": "pcSourceControl"
          }
        },
        {
          "source": {
            "block": "11e471c1-bfeb-49ae-bbde-01c44de63759",
            "port": "pcResult"
          },
          "target": {
            "block": "728f9210-bc5b-4baa-89ff-e8e598a42547",
            "port": "pc_in"
          },
          "size": 32
        },
        {
          "source": {
            "block": "728f9210-bc5b-4baa-89ff-e8e598a42547",
            "port": "pc_out"
          },
          "target": {
            "block": "1851b0c1-5a98-4b83-a540-1bb1415c0891",
            "port": "in"
          },
          "vertices": [
            {
              "x": -1064,
              "y": 1144
            },
            {
              "x": -2328,
              "y": 688
            }
          ],
          "size": 32
        },
        {
          "source": {
            "block": "1851b0c1-5a98-4b83-a540-1bb1415c0891",
            "port": "pc_plus_four"
          },
          "target": {
            "block": "0bf3aff4-1795-4430-a72d-c5b657a82729",
            "port": "pcNext"
          },
          "size": 32
        },
        {
          "source": {
            "block": "1851b0c1-5a98-4b83-a540-1bb1415c0891",
            "port": "pc_plus_four"
          },
          "target": {
            "block": "11e471c1-bfeb-49ae-bbde-01c44de63759",
            "port": "pcPlusFour"
          },
          "size": 32
        },
        {
          "source": {
            "block": "1851b0c1-5a98-4b83-a540-1bb1415c0891",
            "port": "pcPlusJal"
          },
          "target": {
            "block": "11e471c1-bfeb-49ae-bbde-01c44de63759",
            "port": "pcPlusJal"
          },
          "vertices": [
            {
              "x": -1824,
              "y": 712
            }
          ],
          "size": 32
        },
        {
          "source": {
            "block": "1851b0c1-5a98-4b83-a540-1bb1415c0891",
            "port": "pcPlusBOffset"
          },
          "target": {
            "block": "11e471c1-bfeb-49ae-bbde-01c44de63759",
            "port": "pcPlusBOffset"
          },
          "size": 32
        },
        {
          "source": {
            "block": "3efc3b79-af25-412c-8183-e72e8b33c8be",
            "port": "result"
          },
          "target": {
            "block": "1851b0c1-5a98-4b83-a540-1bb1415c0891",
            "port": "regDiff"
          },
          "vertices": [
            {
              "x": -1736,
              "y": 32
            }
          ],
          "size": 32
        }
      ]
    }
  },
  "dependencies": {}
}