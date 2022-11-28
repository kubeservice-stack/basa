CREATE TABLE IF NOT EXISTS `user` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(200) NOT NULL DEFAULT ''  COMMENT 'name',
    `password` varchar(255) NOT NULL DEFAULT ''  COMMENT 'password',
    `salt` varchar(32) NOT NULL DEFAULT ''  COMMENT 'salt',
    `email` varchar(200) NOT NULL DEFAULT ''  COMMENT 'email',
    `display` varchar(200) NOT NULL DEFAULT ''  COMMENT 'display',
    `comment` longtext COMMENT 'comment',
    `type` integer NOT NULL DEFAULT 0  COMMENT 'type',
    `admin` bool NOT NULL DEFAULT False  COMMENT 'admin',
    `last_login` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'last_login',
    `last_ip` varchar(200) NOT NULL DEFAULT ''  COMMENT 'last_ip',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    UNIQUE KEY `uniq_user_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='user';

CREATE TABLE IF NOT EXISTS `app` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `namespace_id` bigint NOT NULL DEFAULT '0'  COMMENT 'namespace_id',
    `meta_data` longtext COMMENT 'meta_data',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    `migrated` bool NOT NULL DEFAULT false  COMMENT 'migrated',
    KEY `idx_app_name` (`name`),
    KEY `idx_app_namespace_id` (`namespace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='app';

CREATE TABLE IF NOT EXISTS `app_starred` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `user_id` bigint NOT NULL DEFAULT '0'  COMMENT 'user_id',
    UNIQUE KEY `uniq_app_id_user_id` (`app_id`, `user_id`),
    KEY `idx_app_starred_app_id` (`app_id`),
    KEY `idx_app_starred_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='app_starred';

CREATE TABLE IF NOT EXISTS `app_user` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `user_id` bigint NOT NULL DEFAULT '0'  COMMENT 'user_id',
    `group_id` bigint NOT NULL DEFAULT '0'  COMMENT 'group_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    KEY `idx_app_user_app_id` (`app_id`),
    KEY `idx_app_user_user_id` (`user_id`),
    KEY `idx_app_user_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='app_user';

CREATE TABLE IF NOT EXISTS `namespace_user` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `namespace_id` bigint NOT NULL DEFAULT '0'  COMMENT 'namespace_id',
    `user_id` bigint NOT NULL DEFAULT '0'  COMMENT 'user_id',
    `group_id` bigint NOT NULL DEFAULT '0'  COMMENT 'group_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    KEY `idx_namespace_user_namespace_id` (`namespace_id`),
    KEY `idx_namespace_user_user_id` (`user_id`),
    KEY `idx_namespace_user_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='namespace_user';

CREATE TABLE IF NOT EXISTS `cluster` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `displayname` varchar(512) NOT NULL DEFAULT ''  COMMENT 'displayname',
    `meta_data` longtext COMMENT 'meta_data',
    `master` varchar(128) NOT NULL DEFAULT ''  COMMENT 'master',
    `kube_config` longtext COMMENT 'kube_config',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    `status` integer NOT NULL DEFAULT 0  COMMENT 'status',
    UNIQUE KEY `uniq_cluster_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='cluster';

CREATE TABLE IF NOT EXISTS `namespace` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `kube_namespace` varchar(128) NOT NULL DEFAULT ''  COMMENT 'kube_namespace',
    `meta_data` longtext COMMENT 'meta_data',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_namespace_name` (`name`),
    KEY `idx_namespace_kube_namespace` (`kube_namespace`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='namespace';

CREATE TABLE IF NOT EXISTS `deployment` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_deployment_name` (`name`),
    KEY `idx_deployment_app_id` (`app_id`),
    KEY `idx_deployment_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='deployment';

CREATE TABLE IF NOT EXISTS `deployment_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `deployment_id` bigint NOT NULL DEFAULT '0'  COMMENT 'deployment_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_deployment_template_deployment_id` (`deployment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='deployment_template';

CREATE TABLE IF NOT EXISTS `service` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_service_name` (`name`),
    KEY `idx_service_app_id` (`app_id`),
    KEY `idx_service_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='service';

CREATE TABLE IF NOT EXISTS `service_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `service_id` bigint NOT NULL DEFAULT '0'  COMMENT 'service_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_service_template_service_id` (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='service_template';

CREATE TABLE IF NOT EXISTS `group` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(200) NOT NULL DEFAULT ''  COMMENT 'name',
    `comment` longtext COMMENT 'comment',
    `type` integer NOT NULL DEFAULT 0  COMMENT 'type',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    KEY `idx_group_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='group';

CREATE TABLE IF NOT EXISTS `permission` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(200) NOT NULL DEFAULT ''  COMMENT 'name',
    `comment` longtext COMMENT 'comment',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    KEY `idx_permission_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='permission';

CREATE TABLE IF NOT EXISTS `secret` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_secret_name` (`name`),
    KEY `idx_secret_app_id` (`app_id`),
    KEY `idx_secret_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='secret';

CREATE TABLE IF NOT EXISTS `secret_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `secret_map_id` bigint NOT NULL DEFAULT '0'  COMMENT 'secret_map_id',
    `meta_data` longtext COMMENT 'meta_data',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_secret_template_secret_map_id` (`secret_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='secret_template';

CREATE TABLE IF NOT EXISTS `config_map` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_config_map_name` (`name`),
    KEY `idx_config_map_app_id` (`app_id`),
    KEY `idx_config_map_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='config_map';

CREATE TABLE IF NOT EXISTS `config_map_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `config_map_id` bigint NOT NULL DEFAULT '0'  COMMENT 'config_map_id',
    `meta_data` longtext COMMENT 'meta_data',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_config_map_template_config_map_id` (`config_map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='config_map_template';

CREATE TABLE IF NOT EXISTS `cronjob` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_cronjob_name` (`name`),
    KEY `idx_cronjob_app_id` (`app_id`),
    KEY `idx_cronjob_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='cronjob';

CREATE TABLE IF NOT EXISTS `cronjob_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `cronjob_id` bigint NOT NULL DEFAULT '0'  COMMENT 'cronjob_id',
    `meta_data` longtext COMMENT 'meta_data',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_cronjob_template_cronjob_id` (`cronjob_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='cronjob_template';

CREATE TABLE IF NOT EXISTS `publish_status` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `type` integer NOT NULL DEFAULT 0  COMMENT 'type',
    `resource_id` bigint NOT NULL DEFAULT 0  COMMENT 'resource_id',
    `template_id` bigint NOT NULL DEFAULT 0  COMMENT 'template_id',
    `cluster` varchar(128) NOT NULL DEFAULT ''  COMMENT 'cluster',
    KEY `idx_publish_status_type` (`type`),
    KEY `idx_publish_status_resource_id` (`resource_id`),
    KEY `idx_publish_status_template_id` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='publish_status';

CREATE TABLE IF NOT EXISTS `publish_history` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `type` integer NOT NULL DEFAULT 0  COMMENT 'type',
    `resource_id` bigint NOT NULL DEFAULT 0  COMMENT 'resource_id',
    `resource_name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'resource_name',
    `template_id` bigint NOT NULL DEFAULT 0  COMMENT 'template_id',
    `cluster` varchar(128) NOT NULL DEFAULT ''  COMMENT 'cluster',
    `status` integer NOT NULL DEFAULT 0  COMMENT 'status',
    `message` longtext COMMENT 'message',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    KEY `idx_publish_history_type` (`type`),
    KEY `idx_publish_history_resource_id` (`resource_id`),
    KEY `idx_publish_history_template_id` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='publish_history';

CREATE TABLE IF NOT EXISTS `persistent_volume_claim` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_persistent_volume_claim_name` (`name`),
    KEY `idx_persistent_volume_claim_app_id` (`app_id`),
    KEY `idx_persistent_volume_claim_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='persistent_volume_claim';

CREATE TABLE IF NOT EXISTS `persistent_volume_claim_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `persistent_volume_claim_id` bigint NOT NULL DEFAULT '0'  COMMENT 'persistent_volume_claim_id',
    `meta_data` longtext COMMENT 'meta_data',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_persistent_volume_claim_template_persistent_volume_claim_id` (`persistent_volume_claim_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='persistent_volume_claim_template';

CREATE TABLE IF NOT EXISTS `audit_log` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `subject_id` bigint NOT NULL DEFAULT 0  COMMENT 'subject_id',
    `log_type` varchar(128) NOT NULL DEFAULT ''  COMMENT 'log_type',
    `log_level` varchar(128) NOT NULL DEFAULT ''  COMMENT 'log_level',
    `action` varchar(255) NOT NULL DEFAULT ''  COMMENT 'action',
    `message` longtext COMMENT 'message',
    `user_ip` varchar(200) NOT NULL DEFAULT ''  COMMENT 'user_ip',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    KEY `idx_audit_log_log_type` (`log_type`),
    KEY `idx_audit_log_log_level` (`log_level`),
    KEY `idx_audit_log_action` (`action`),
    KEY `idx_audit_log_user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='audit_log';

CREATE TABLE IF NOT EXISTS `api_key` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `token` longtext COMMENT 'token',
    `type` integer NOT NULL DEFAULT 0  COMMENT 'type',
    `resource_id` bigint NOT NULL DEFAULT 0  COMMENT 'resource_id',
    `group_id` bigint COMMENT 'group_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `expire_in` bigint NOT NULL DEFAULT 0  COMMENT 'expire_in',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    KEY `idx_api_key_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='api_key';

CREATE TABLE IF NOT EXISTS `web_hook` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `scope` bigint NOT NULL DEFAULT 0  COMMENT 'scope',
    `object_id` bigint NOT NULL DEFAULT 0  COMMENT 'object_id',
    `url` varchar(512) NOT NULL DEFAULT ''  COMMENT 'url',
    `secret` varchar(512) NOT NULL DEFAULT ''  COMMENT 'secret',
    `events` longtext COMMENT 'events',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `enabled` bool NOT NULL DEFAULT false  COMMENT 'enabled',
    UNIQUE KEY `uniq_scope_object_id_name` (`scope`, `object_id`, `name`),
    KEY `idx_web_hook_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='web_hook';

CREATE TABLE IF NOT EXISTS `statefulset` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_statefulset_name` (`name`),
    KEY `idx_statefulset_app_id` (`app_id`),
    KEY `idx_statefulset_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='statefulset';

CREATE TABLE IF NOT EXISTS `statefulset_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `statefulset_id` bigint NOT NULL DEFAULT '0'  COMMENT 'statefulset_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_statefulset_template_statefulset_id` (`statefulset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='statefulset_template';

CREATE TABLE IF NOT EXISTS `config` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(256) NOT NULL DEFAULT ''  COMMENT 'name',
    `value` longtext COMMENT 'value'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='config';

CREATE TABLE IF NOT EXISTS `daemon_set` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_daemon_set_name` (`name`),
    KEY `idx_daemon_set_app_id` (`app_id`),
    KEY `idx_daemon_set_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='daemon_set';

CREATE TABLE IF NOT EXISTS `daemon_set_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `daemon_set_id` bigint NOT NULL DEFAULT '0'  COMMENT 'daemon_set_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_daemon_set_template_daemon_set_id` (`daemon_set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='daemon_set_template';

CREATE TABLE IF NOT EXISTS `charge` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `namespace` varchar(1024) NOT NULL DEFAULT ''  COMMENT 'namespace',
    `app` varchar(128) NOT NULL DEFAULT ''  COMMENT 'app',
    `name` varchar(1024) NOT NULL DEFAULT ''  COMMENT 'name',
    `type` varchar(128) NOT NULL DEFAULT ''  COMMENT 'type',
    `unit_price` numeric(12, 4) NOT NULL DEFAULT 0  COMMENT 'unit_price',
    `quantity` integer NOT NULL DEFAULT 0  COMMENT 'quantity',
    `amount` numeric(12, 4) NOT NULL DEFAULT 0  COMMENT 'amount',
    `resource_name` varchar(1024) NOT NULL DEFAULT ''  COMMENT 'resource_name',
    `start_time` datetime NOT NULL DEFAULT '1970-01-02 00:00:00'  COMMENT 'start_time',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    KEY `idx_charge_app` (`app`),
    KEY `idx_charge_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='charge';

CREATE TABLE IF NOT EXISTS `invoice` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `namespace` varchar(1024) NOT NULL DEFAULT ''  COMMENT 'namespace',
    `app` varchar(128) NOT NULL DEFAULT ''  COMMENT 'app',
    `amount` numeric(12, 4) NOT NULL DEFAULT 0  COMMENT 'amount',
    `start_date` datetime NOT NULL DEFAULT '1970-01-02 00:00:00'  COMMENT 'start_date',
    `end_date` datetime NOT NULL DEFAULT '1970-01-02 00:00:00'  COMMENT 'end_date',
    `bill_date` datetime NOT NULL DEFAULT '1970-01-02 00:00:00'  COMMENT 'bill_date',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    KEY `idx_invoice_app` (`app`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='invoice';

CREATE TABLE IF NOT EXISTS `notification` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `type` varchar(128) NOT NULL DEFAULT ''  COMMENT 'type',
    `title` varchar(2000) NOT NULL DEFAULT ''  COMMENT 'title',
    `message` longtext COMMENT 'message',
    `from_user_id` bigint NOT NULL DEFAULT '0'  COMMENT 'from_user_id',
    `level` integer NOT NULL DEFAULT 0  COMMENT 'level',
    `is_published` bool NOT NULL DEFAULT false  COMMENT 'is_published',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    KEY `idx_notification_type` (`type`),
    KEY `idx_notification_from_user_id` (`from_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='notification';

CREATE TABLE IF NOT EXISTS `notification_log` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `user_id` bigint NOT NULL DEFAULT 0  COMMENT 'user_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `is_readed` bool NOT NULL DEFAULT false  COMMENT 'is_readed',
    `notification_id` bigint NOT NULL DEFAULT '0'  COMMENT 'notification_id',
    KEY `idx_notification_log_notification_id` (`notification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='notification_log';

CREATE TABLE IF NOT EXISTS `ingress` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(255) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_ingress_name` (`name`),
    KEY `idx_ingress_app_id` (`app_id`),
    KEY `idx_ingress_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ingress';

CREATE TABLE IF NOT EXISTS `ingress_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `ingress_id` bigint NOT NULL DEFAULT '0'  COMMENT 'ingress_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_ingress_template_ingress_id` (`ingress_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ingress_template';

CREATE TABLE IF NOT EXISTS `hpa` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `meta_data` longtext COMMENT 'meta_data',
    `app_id` bigint NOT NULL DEFAULT '0'  COMMENT 'app_id',
    `description` varchar(255) NOT NULL DEFAULT ''  COMMENT 'description',
    `order_id` bigint NOT NULL DEFAULT 0  COMMENT 'order_id',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_hpa_name` (`name`),
    KEY `idx_hpa_app_id` (`app_id`),
    KEY `idx_hpa_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='hpa';

CREATE TABLE IF NOT EXISTS `hpa_template` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `name` varchar(128) NOT NULL DEFAULT ''  COMMENT 'name',
    `template` longtext COMMENT 'template',
    `hpa_id` bigint NOT NULL DEFAULT '0'  COMMENT 'hpa_id',
    `description` varchar(512) NOT NULL DEFAULT ''  COMMENT 'description',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'create_time',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'update_time',
    `user` varchar(128) NOT NULL DEFAULT ''  COMMENT 'user',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    KEY `idx_hpa_template_hpa_id` (`hpa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='hpa_template';

CREATE TABLE IF NOT EXISTS `link_type` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `type_name` varchar(255) NOT NULL DEFAULT ''  COMMENT 'type_name',
    `displayname` varchar(255) NOT NULL DEFAULT ''  COMMENT 'displayname',
    `default_url` varchar(255) NOT NULL DEFAULT ''  COMMENT 'default_url',
    `param_list` varchar(255) NOT NULL DEFAULT ''  COMMENT 'param_list',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    UNIQUE KEY `uniq_link_type_type_name` (`type_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='link_type';

CREATE TABLE IF NOT EXISTS `custom_link` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `namespace` varchar(255) NOT NULL DEFAULT ''  COMMENT 'namespace',
    `link_type` varchar(255) NOT NULL DEFAULT ''  COMMENT 'link_type',
    `url` varchar(255) NOT NULL DEFAULT ''  COMMENT 'url',
    `add_param` bool NOT NULL DEFAULT false  COMMENT 'add_param',
    `params` varchar(255) NOT NULL DEFAULT ''  COMMENT 'params',
    `deleted` bool NOT NULL DEFAULT false  COMMENT 'deleted',
    `status` bool NOT NULL DEFAULT true  COMMENT 'status',
    KEY `idx_custom_link_namespace` (`namespace`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='custom_link';

CREATE TABLE IF NOT EXISTS `group_permissions` (
    `id` bigint AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'id',
    `group_id` bigint NOT NULL DEFAULT '0'  COMMENT 'group_id',
    `permission_id` bigint NOT NULL DEFAULT '0'  COMMENT 'permission_id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='group_permissions';
