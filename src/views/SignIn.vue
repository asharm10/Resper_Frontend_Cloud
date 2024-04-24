<template>
  <v-app id="inspire">

    <v-content>
      <Navbar />
      <v-container mt-10>
        <v-layout align-center justify-center>

          <v-flex xs12 sm8 md4>
            <v-card class="elevation-12">
              <v-card-title>
                Sign In
              </v-card-title>
              <v-card-text>
                <v-form @submit.prevent="signIn">
                  <v-text-field name="username" v-model="username" label="Email" type="text"></v-text-field>
                  <v-text-field id="password" name="password" v-model="password" label="Password" type="password">
                  </v-text-field>
                  <v-card-actions>
                    <v-col>
                      <v-btn type="submit" class="mb-5" block color="error">Login</v-btn>
                      <v-btn block color="error" to="/admin/register">Register</v-btn>
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
    name: "SignIn",
    data() {
      return {
        username: "",
        password: "",
      };
    },
    methods: {
      async signIn() {
        const { username, password } = this;
        const res = await fetch(process.env.VUE_APP_BACKEND_URL + "admin/login", {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          credentials: "include",
          body: JSON.stringify({
            username,
            password
          })
        });
        const data = await res.json();
        // console.log(data)
        if (data.status === 200) {
          localStorage.setItem('restaurantID', data.success.restaurantID);
          this.$store.dispatch("setToken", res.status);
          this.$router.push("/admin");
          console.log("hello world")
        }
        else {
          alert("Invalid credentials");
        }
      }
    },
    components: { Navbar }
  };
</script>
