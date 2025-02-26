# V SSH Config Manager

A simple command-line tool written in V to manage your SSH config file. This tool allows you to easily add, remove, and list SSH hosts configurations without manually editing the SSH config file.

## Features

- Add new SSH hosts with custom settings
- List all configured SSH hosts
- Remove existing SSH hosts
- Automatic config file management
- Simple command-line interface

## Installation

### Prerequisites

- V programming language (latest version)
- Git

### Building from source

```bash
git clone https://github.com/JaphetSamuel/vsash
cd vsash
v .
```

## Usage

### Adding a new host

```bash
vsash-c add -n myserver -h example.com -u myuser -p 2222 -i ~/.ssh/id_rsa
```

Parameters:
- `-n, --name`: Host name (required)
- `-h, --hostname`: Host address (required)
- `-u, --user`: Username (required)
- `-p, --port`: Port number (optional, default: 22)
- `-i, --identity`: Path to identity file (optional)

### Listing all hosts

```bash
vsash-c list
```

This will display all configured hosts with their settings.

### Removing a host

```bash
vsash-c remove -n myserver
```

Parameters:
- `-n, --name`: Host name to remove (required)

## Configuration

The tool automatically manages your SSH config file located at `~/.ssh/config`. A backup of the existing configuration is created before any modifications.

## Structure

```
.
├── src/
│   ├── main.v
│   └── config_manager.v
├── README.md
└── v.mod
```

## Contributing

Contributions are welcome! Here are some ways you can contribute:

1. Report bugs
2. Suggest new features
3. Submit pull requests

Please ensure your pull requests are well-documented and include appropriate test cases.

## Planned Features

- [ ] Edit existing host configurations
- [ ] Import/Export configurations
- [ ] Backup management
- [ ] Host configuration validation
- [ ] Support for additional SSH config options
- [ ] Configuration groups

## License

This project is licensed under the MIT License 

## Acknowledgments

- The V programming language team
- Contributors to the project

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.
