module.exports = {
  apps: [{
    name: 'mojdoc',
    script: 'hypnotoad',
    args: ['-f', 'mojdoc'],
    interpreter: 'none',
    exec_mode: 'fork',
    instances: 1,
    env: {
      MOJDOC_WELCOME: 'private/welcome.md',
      MOJDOC_LOGIT: 1,
      MOJDOC_BADGE: 'your-dox',
      MOJO_MODE: 'production',
    }
  }]
};
