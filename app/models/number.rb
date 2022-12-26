class Number < ActiveHash::Base
  self.data = [
    { id: 0, name: '---' },
    { id: 1, name: 1 },
    { id: 2, name: 1.5 },
    { id: 3, name: 2 },
    { id: 4, name: 2.5 },
    { id: 5, name: 3 },
    { id: 6, name: 3.5 },
    { id: 7, name: 4 },
    { id: 8, name: 4.5 },
    { id: 9, name: 5 },
    { id: 10, name: 5.5 },
    { id: 11, name: 6 },
  ]
end