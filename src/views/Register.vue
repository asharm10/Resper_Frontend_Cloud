<template>
  <v-app id="inspire">
    <v-content>
      <Navbar/>
      <v-container mt-10>
        <v-layout align-center justify-center>
          <v-flex xs12 sm8 md4>
            <v-card class="elevation-12">
              <v-card-title>
                Register
              </v-card-title>
              <v-card-text>
                <v-form @submit.prevent="register" ref="form" v-model="valid" lazy-validation>
                  <v-text-field name="username" v-model="username" label="Email" type="text" :rules="emailRules"
                    required></v-text-field>
                  <v-text-field name="fullname" :rules="nameRules" v-model="fullname" label="Full Name" type="text"
                    required></v-text-field>
                  <v-text-field name="restaurantName" v-model="restaurantName" :rules="nameRules"
                    label="Restaurant Name" type="text" required></v-text-field>
                  <v-text-field id="password" name="password" v-model="password" label="Password" type="password"
                    :rules="nameRules" required>
                  </v-text-field>
                  <v-card-actions>
                    <v-col>
                      <v-btn type="submit" class="mb-5" block color="error">Register</v-btn>
                      <v-btn block color="error" to="/admin/signin">Sign In</v-btn>
                    </v-col>
                  </v-card-actions>
                </v-form>
              </v-card-text>
            </v-card>
          </v-flex>
        </v-layout>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
import Navbar from "../components/Navbar.vue";
export default {
    name: "RegisterName",
    data() {
        return {
            username: "",
            valid: true,
            password: "",
            fullname: "",
            restaurantName: "",
            nameRules: [
                v => !!v || "Field is required",
            ],
            emailRules: [
                v => !!v || "E-mail is required",
                v => /.+@.+\..+/.test(v) || "E-mail must be valid",
            ],
            passwordRules: [
                v => !!v || "Field is required",
            ],
        };
    },
    methods: {
        async register() {
            const isValid = this.$refs.form.validate();
            if (!isValid) {
                return;
            }
            const { username, password, fullname, restaurantName } = this;
            const res = await fetch(process.env.VUE_APP_BACKEND_URL + "admin/register", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    username,
                    password,
                    fullname,
                    restaurantName
                })
            });
            const data = await res.json();
            console.log(data);
            if (data.status == 200) {
                this.$router.push("/admin/signin");
          
            }
            else {
                alert("Error: User with that email already exists");
            }
        }
    },
    components: { Navbar }
};
</script>

<style>
body {
  background-color: #F0F0F0;
}

h1 {
  padding: 0;
  margin-top: 0;
}

#app {
  width: 1024px;
  margin: auto;
}
</style>