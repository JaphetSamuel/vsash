module main

import os
import flag
// import encoding.json

// Structure pour un hôte SSH
struct SSHHost {
mut:
    name        string
    hostname    string
    user        string
    port        int    = 22
    identity    string
}

// Structure principale du gestionnaire
struct ConfigManager {
mut:
    config_path string
    hosts      []SSHHost
}

// Initialise le gestionnaire de configuration
fn new_config_manager() ?ConfigManager {
    home_dir := os.home_dir()
    config_path := os.join_path(home_dir, '.ssh', 'config')
    
    return ConfigManager{
        config_path: config_path
        hosts: []SSHHost{}
    }
}

// Ajoute un nouvel hôte
fn (mut cm ConfigManager) add_host(host SSHHost) ! {
    // Vérifie si l'hôte existe déjà
    for h in cm.hosts {
        if h.name == host.name {
            println('Host ${host.name} already exists')
			return
        }
    }
    
    cm.hosts << host
    cm.save_config() or {
		return err
	}
}

// Liste tous les hôtes
fn (cm ConfigManager) list_hosts() []SSHHost {
    return cm.hosts
}

// Supprime un hôte
fn (mut cm ConfigManager) remove_host(name string) ! {
    mut found := false
    for i, host in cm.hosts {
        if host.name == name {
            cm.hosts.delete(i)
            found = true
            break
        }
    }
    
    if !found {
        println('Host ${name} not found')
		return
    }
    
    cm.save_config()!
}

// Sauvegarde la configuration
fn (cm ConfigManager) save_config() ! {
    mut config_content := ''
    
    for host in cm.hosts {
        config_content += 'Host ${host.name}\n'
        config_content += '    HostName ${host.hostname}\n'
        config_content += '    User ${host.user}\n'
        config_content += '    Port ${host.port}\n'
        if host.identity != '' {
            config_content += '    IdentityFile ${host.identity}\n'
        }
        config_content += '\n'
    }
    
    os.write_file(cm.config_path, config_content)!
}

// Point d'entrée principal
fn main() {
    mut fp := flag.new_flag_parser(os.args)
    fp.application('vsash')
    fp.version('v0.1.0')
    fp.description('A simple SSH config manager written in V')
    
    cmd := fp.string('cmd', `c`, '', 'Command to execute (add|list|remove)')
    name := fp.string('name', `n`, '', 'Host name')
    hostname := fp.string('hostname', `h`, '', 'Host address')
    user := fp.string('user', `u`, '', 'Username')
    port := fp.int('port', `p`, 22, 'Port number')
    identity := fp.string('identity', `i`, '', 'Identity file path')
    
    fp.finalize() or {
        eprintln(err)
        return
    }
    
    mut manager := new_config_manager() or {
        eprintln('Failed to initialize config manager: ${err}')
        return
    }
    
    match cmd {
        'add' {
            if name == '' || hostname == '' || user == '' {
                eprintln('Name, hostname and user are required for add command')
                return
            }
            
            host := SSHHost{
                name: name
                hostname: hostname
                user: user
                port: port
                identity: identity
            }
            
            manager.add_host(host) or {
                eprintln('Failed to add host: ${err}')
                return
            }
            println('Host ${name} added successfully')
        }
        'list' {
            hosts := manager.list_hosts()
            for host in hosts {
                println('${host.name}:')
                println('  Hostname: ${host.hostname}')
                println('  User: ${host.user}')
                println('  Port: ${host.port}')
                if host.identity != '' {
                    println('  Identity: ${host.identity}')
                }
                println('')
            }
        }
        'remove' {
            if name == '' {
                eprintln('Name is required for remove command')
                return
            }
            
            manager.remove_host(name) or {
                eprintln('Failed to remove host: ${err}')
                return
            }
            println('Host ${name} removed successfully')
        }
        else {
            eprintln('Invalid command. Use add, list, or remove')
        }
    }
}