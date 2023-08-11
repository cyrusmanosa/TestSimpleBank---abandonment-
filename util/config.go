package util

import "github.com/spf13/viper"

// Config stores all configuration of the application
// the values are read by viper from a config file or environment variable.
type Config struct {
	DBDriver      string `mapstructure:"DB_Driver"`
	DBSource      string `mapstructure:"DB_Source"`
	ServerAddress string `mapstructure:"SERVER_ADDRESS"`
}

// LoadConfig reads the configuration from file or environment variable
func LoadConfig(path string) (config Config, err error) {
	viper.AddConfigPath(path)
	viper.SetConfigName("app")
	viper.SetConfigType("env")

	viper.AutomaticEnv()

	err = viper.ReadInConfig()
	if err != nil {
		return
	}
	err = viper.Unmarshal(&config)
	return
}
