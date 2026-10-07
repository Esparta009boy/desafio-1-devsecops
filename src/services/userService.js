const users = [];

const getAllUsers = () => {
  return users;
};

const createUser = (name, email) => {
  const newUser = {
    id: users.length + 1,
    name,
    email,
    createdAt: new Date()
  };

  users.push(newUser);
  return newUser;
};

module.exports = {
  getAllUsers,
  createUser
};
