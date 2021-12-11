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
        }
      ]
    }
  },
  "dependencies": {}
}